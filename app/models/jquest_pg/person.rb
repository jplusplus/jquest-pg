module JquestPg
  class Person < ActiveRecord::Base
    has_paper_trail
    has_many :mandatures
    has_many :sources, foreign_key: :resource_id
    after_update :track_activities

    def display_name
      fullname
    end

    def track_activities
      # Find the last version of this model
      uid = self.versions.last.nil? ? nil : self.versions.last.whodunnit
      # This someone must exist!
      unless uid.nil?
        # Find the user
        user = User.find uid
        # Get user progression
        progression = JquestPg::ApplicationController.new.progression user
        # Create a taxonomy for this level and round
        task_taxonomy = "level:#{progression[:level]}:round:#{progression[:round]}:task:finished"
        # Find assignment for this user...
        assignment = user.assignments.
          # ...joins through the mandatures table using the assignment's resource_id
          joins('INNER JOIN jquest_pg_mandatures ON jquest_pg_mandatures.id = assignments.resource_id').
          # ...filter mandatures with person id
          find_by(jquest_pg_mandatures: { person_id: self.id })
        # Does the gender have been touch (even if it didn't changed)
        if self.gender_touched? and progression[:round] == 1
          # We found it!
          unless assignment.nil?
            # Take its id
            aid = assignment.id
            # And save the activity
            Activity.find_or_create_by user: user, taxonomy: task_taxonomy, value: aid, points: 1
          end
        else progression[:round] == 2
          # We found it!
          unless assignment.nil?
            changed =begin
              # Attributes that might changed
              [:birthdate, :birthplace, :education, :profession_category].select do |n|
                # Did it changed?
                self.method("#{n}_changed?").call
              end
            end
            # If at leat 2 changed..
            if changed.length >= 2
              # We found it!
              unless assignment.nil?
                # Take its id
                aid = assignment.id
                # And save the activity
                Activity.find_or_create_by user: user, taxonomy: task_taxonomy, value: aid, points: 5
              end
            end
          end
        end
        # We set the round as "finished" after 6 persons have been edited
        if Activity.where(user: user, taxonomy: task_taxonomy).count(:all) >= 6
          round_taxonomy = "level:#{progression[:level]}:round:finished"
          # Save the activity saying the round is finished!
          Activity.find_or_create_by user: user, taxonomy: round_taxonomy, value: progression[:round]
          # We set the level as "finished" after round persons have been finished
          if Activity.where(user: user, taxonomy: round_taxonomy).count(:all) >= 3
            level_taxonomy = "level:finished"
            # Save the activity saying the round is finished!
            Activity.find_or_create_by user: user, taxonomy: level_taxonomy, value: progression[:level]
          end
        end
      end
    end

    def gender=(value)
      super
      # To track touch on gender field (even if the value didn't changed)
      @gender_touched = true
    end

    def gender_touched?
      @gender_touched.present? and @gender_touched
    end

    def self.assigned_to(user, season=user.member_of, force=true)
      Mandature.assigned_to(user).includes(:person).map(&:person)
    end
  end
end
