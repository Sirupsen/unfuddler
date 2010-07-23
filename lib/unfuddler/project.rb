module Unfuddler
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
end
