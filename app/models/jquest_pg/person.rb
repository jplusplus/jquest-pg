module JquestPg
  class Person < ActiveRecord::Base
    include CsvAttributes

    has_paper_trail
    has_many :mandatures
    has_many :sources, foreign_key: :resource_id
    after_update :track_activities

    def self.csv_attributes
      %w{fullname email education profession_category profession
        image twitter facebook gender birthdate birthplace phone}
    end

    def display_name
      fullname
    end

    def to_s
      display_name
    end

    def track_activities
      # Find the last version of this model
      uid = versions.last.nil? ? nil : versions.last.whodunnit
      # This someone must exist!
      return if uid.nil?
      # Find the user
      user = User.find uid
      # Find assignment for this user...
      assignment = as_assignments.where(user: user).first
      # This assignment must exist!
      return if assignment.nil?
      # Get user progression
      progression = JquestPg::ApplicationController.new.progression user
      # Build a hash describing the new activity
      activity = { user: user, resource: self, assignment: assignment }
      # ROUND 1
      # Does the gender have been touch (even if it didn't changed)
      if gender_touched? and progression[:round] == 1
        # And save the activity
        Activity.find_or_create_by **activity.merge!(taxonomy: 'genderize', points: 1)
      # ROUND 2
      # Multiple value may have changed
      else
        # Attributes that might changed
        [:birthdate, :birthplace, :education, :profession_category].each do |n|
          # Did it changed?
          if method("#{n}_changed?").call
            activity.merge! points: 2, taxonomy: 'details', value: n
            # And save the activity
            Activity.find_or_create_by **activity
          end
        end
      end
    end

    def age
      unless birthdate.blank?
        Time.now.year - Time.parse(birthdate).year
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

    def as_assignments
      Assignment.
        # ...joins through the mandatures table using the assignment's resource_id
        joins('INNER JOIN jquest_pg_mandatures ON jquest_pg_mandatures.id = assignments.resource_id').
        # ...filter mandatures with person id
        where(jquest_pg_mandatures: { person_id: id })
    end

    def self.assigned_to(user, season=user.member_of, force=true, status=nil)
      ids = Mandature.
                assigned_to(user, season, force, status).
                includes(:person).
                map(&:person_id)
      where(id: ids)
    end

    def self.unassigned_to(user, season=user.member_of, force=true, status=nil)
      # Ids of the people not assigned to that user
      pids = Mandature.
                  assigned_to(user, season, force, status).
                  includes(:person).
                  distinct.
                  pluck(:person_id)
      # Persons matching those ids
      where.not(id: pids)
    end

  end
end
