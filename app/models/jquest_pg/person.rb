module JquestPg
  class Person < ActiveRecord::Base
    has_paper_trail
    has_many :mandatures

    def display_name
      fullname
    end

    def self.assign_to!(user)
      # Get the list of legislatures that can be assigned to the user
      assignable_legislatures = Legislature.assignable_to user
      if assignable_legislatures.length
        # Number of persons picked from each legislatures depends of the number of legislature
        persons_per_legislatures = (6 / assignable_legislatures.length).ceil
      else
        Person.none
      end
    end

    def self.assigned_to(user)
      ids = user.assignments.where(resource_type: Person).map(&:id)
      where(id: ids)
    end
  end
end
