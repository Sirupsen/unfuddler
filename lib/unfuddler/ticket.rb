module Unfuddler
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
