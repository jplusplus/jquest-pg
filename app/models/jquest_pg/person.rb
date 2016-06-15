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
      legislatures = Legislature.where difficulty_level: progression[:level]
      # Different assignement according the language
      case progression[:level]
      # LEVEL 1
      #   * legislature.end_date after the current year
      #   * legislature.country is user.home_country
      #   * legislature.languages includes user.spoken_language
      when 1
        legislatures = legislatures.where country: user.home_country
        # Filter legislate that use the same language than the user
        legislatures = legislatures.select do |legislature|
          legislature.languages.split(',').map(&:strip).include? user.spoken_language
        end
      end
    end

    def self.assigned_to(user)
      ids = user.assignments.where(resource_type: Person).map(&:id)
      where(id: ids)
    end
  end
end
