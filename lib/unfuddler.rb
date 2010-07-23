%w{
  hashie
  net/http
  crack/xml
  active_support
  active_support/core_ext/hash
}.each {|lib| require lib}

module Unfuddler
  class << self
    attr_accessor :username, :password, :subdomain, :http

    def authenticate(info)
      @username, @password, @subdomain = info[:username] || info["username"], info[:password] || info["password"], info[:subdomain] || info["subdomain"]
      @http = Net::HTTP.new("#{@subdomain}.unfuddle.com", 80)
    end

    def authenticated?
      true if @http
    end

    def request(type, url, data = nil)
      raise "Not authenticated!" unless authenticated?

      request = eval("Net::HTTP::#{type.to_s.capitalize}").new("/api/v1/#{url}", {'Content-type' => "application/xml"})
      request.basic_auth @username, @password

      request.body = data if data
      request = @http.request(request)

      handle_response(request.body, request.code)
    end

    def handle_response(body, code)
      valid_codes = [201, 200, 302]
      raise "Server returned response code: " + code unless valid_codes.include?(code.to_i)

      Crack::XML.parse(body)
    end

    [:get, :put, :post, :delete].each do |method|
      define_method(method) do |*args|
        # Ruby 1.8 fix, in 1.9 we could just do define.. do |url, data = nil|
        url, data = args
        request(method, url, data)
      end
    end

    def parse_specification(objects, specification)
      if specification.is_a?(String)
        objects.collect { |object| object if object.short_name == specification.to_s }
      elsif specification.is_a?(Hash)
        finder(objects, specification)
      elsif specification.is_a?(Fixnum)
        finder(objects, {:id => specification})
      elsif specification == :all
        objects
      elsif specification == :first
        objects.first
      elsif specification == :last
        objects.last
      else
        objects
      end
    end

    def finder(objects, specification)
      f_objects = objects.collect do |object|
        matches = 0
        specification.each_pair do |method, expected_value|
          matches += 1 if object.send(method) == expected_value
        end

        object if matches == specification.length
      end

      f_objects.compact
    end
  end

  class Project < Hashie::Mash
    def self.find(specification = nil)
      projects = Unfuddler.get("projects.xml")["projects"].collect {|project| Project.new(project)}

      Unfuddler.parse_specification(projects, specification)
    end

    def tickets(argument = nil)
      Ticket.find(self.id, argument)
    end

    def ticket(argument = nil)
      Ticket.find(self.id, argument).first
    end

    def ticket!(ticket)
      Ticket.create(self.id, ticket)
    end
  end

  class Ticket < Hashie::Mash
    # Find tickets associated with a project.
    #
    # Required argument is project_id, which is the id
    # of the project to search for tickets.
    #
    # Optional argument is argument, which searches the tickets
    # to match the keys in the argument. e.g.
    #   Ticket.find(:status => "new")
    # Returns all tickets with status "new"
    def self.find(project_id, specifications = nil)
      tickets = []
      Unfuddler.get("projects/#{project_id}/tickets.xml")["tickets"].each do |project|
        tickets << Ticket.new(project)
      end

      Unfuddler.parse_specification(tickets, specifications)
    end

    # Save ticket
    #
    # Optional argument is what to update if the ticket object is not altered
    def save(update = nil)
      update = self.to_hash.to_xml(:root => "ticket") unless update
      Unfuddler.put("projects/#{self.project_id}/tickets/#{self.id}", update)
    end

    # Create a ticket
    #
    # Optional argument is project_id
    def self.create(project_id, ticket)
      if ticket.is_a?(Unfuddler::Ticket)
        ticket = ticket.to_hash.to_xml(:root => "ticket")
      else
        ticket = ticket.to_xml(:root => "ticket")
      end

      Unfuddler.post("projects/#{project_id or self.project_id}/tickets", ticket)
    end
    
    [:closed!, :new!, :unaccepted!, :reassigned!, :reopened!, :accepted!, :resolved!].each do |method|
      # Fix method names, e.g. #reassigned! => #reassign!
      length = method.to_s[0..-3] if method == :closed!
      length = method.to_s[0..-2] if [:new!, :resolved!].include?(method)
      
      define_method((length || method.to_s[0..-4]) + "!") do |*args|
        name = method.to_s[0..-2] # No "!"
        update = {:status => name}

        resolution = args.first
        unless resolution.empty?
          # The API wants resolution-description for a resolutions description,
          # to make it more user-friendly, we convert this automatically
          resolution[:"resolution-description"] = resolution.delete(:description)
          update.merge!(resolution)
        end
        
        update = update.to_xml(:root => "ticket")
        save(update)
      end
    end

    def delete
      Unfuddler.delete("projects/#{self.project_id}/tickets/#{self.id}")
    end

    alias_method :delete!, :delete
  end
end
