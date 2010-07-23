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
  end

  class Project < Hashie::Mash
    def self.find(specification = nil)

      projects = []
      Unfuddler.get("projects.xml")["projects"].each do |project|
        projects << Project.new(project)
      end

      if specification.is_a?(String)
        return projects.collect { |project| project if project.short_name == specification }
      elsif specification.is_a?(Hash)
        # Check each ticket if all the expected values pass, return all
        # tickets where everything passes in an array
        return projects.collect do |project|
          matches = 0
          specification.each_pair do |method, expected_value|
            matches += 1 if project.send(method) == expected_value
          end
          
          project if matches == specification.length
        end
      elsif specification == :all
        projects
      elsif specification == :first
        projects.first
      elsif specification == :last
        projects.last
      else
        projects
      end
    end

    def self.[](name = nil)
      self.find(name)
    end

    def tickets(argument = nil)
      Ticket.find(self.id, argument)
    end

    def ticket
      Ticket::Interacter.new(self.id)
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
    def self.find(project_id, arguments = nil)
      tickets = []
      Unfuddler.get("projects/#{project_id}/tickets.xml")["tickets"].each do |project|
        tickets << Ticket.new(project)
      end
      
      if arguments
        specified_tickets = []
        
        # Check each ticket if all the expected values pass, return all
        # tickets where everything passes in an array
        tickets.each do |ticket|
          matches = 0
          arguments.each_pair do |method, expected_value|
            matches += 1 if ticket.send(method) == expected_value
          end
          
          specified_tickets << ticket if matches == arguments.length
        end
        
        return specified_tickets
      end

      tickets
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
    def create(project_id = nil)
      ticket = self.to_hash.to_xml(:root => "ticket")
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

    class Interacter
      def initialize(project_id)
        @project_id = project_id
      end

      def create(ticket = {})
        ticket = Ticket.new(ticket)
        ticket.create(@project_id)
      end
    end
  end
end
