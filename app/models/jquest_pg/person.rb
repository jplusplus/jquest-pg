module JquestPg
  class Person < ActiveRecord::Base
    has_paper_trail

    def display_name
      fullname
    end

    def self.assign_to!(user)
      # Gets user progression
      progression = JquestPg::ApplicationController.new.progression
      # Gets legislature for her level of progression
      legislatures = Legislature.where difficulty_level: progression[:level],
                                       country: user.school.country
    end

    def self.assigned_to(user)
      ids = user.assignments.where(resource_type: Person).map(&:id)
      where(id: ids)
    end
  end
end
