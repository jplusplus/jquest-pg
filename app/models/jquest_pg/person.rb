module JquestPg
  class Person < ActiveRecord::Base
    include CsvAttributes

    has_paper_trail :on => [:update]
    has_many :mandatures, :dependent => :delete_all
    has_many :sources, foreign_key: :resource_id
    after_update :track_activities

    def self.csv_attributes
      %w{fullname email education profession_category profession
        image twitter facebook gender birthdate birthplace phone}
    end

    def display_name
      fullname
    end

    def description
      @description ||=begin
        description = []
        description << (fullname || '').strip + ','
        description << "was born" if birthdate? or birthplace?
        description << "in #{birthplace.strip}" if birthplace?
        description << "the #{birthdate}" if birthdate?
        description << "member of" if mandatures.length > 0
        # Add each mandatures to the description
        mandatures.each_with_index.map do |mandature, i|
          if i > 0
            if i == mandatures.length - 1
              description << 'and'
            else
              description << ','
            end
          end
          description << "« #{mandature.legislature.name.strip} »"
        end
        # Joins the description array as one sentence
        description * ' '
      end
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
      # Build a hash describing the new activity
      activity = { user: user, resource: self, assignment: assignment }
      # Does the gender have been touch (even if it didn't changed)
      if gender_touched?
        # And save the activity
        Activity.find_or_create_by **activity.merge!(taxonomy: 'genderize', points: 1)
      end
      # Multiple value may have changed
      [:birthdate, :birthplace, :education, :profession_category, :image].each do |n|
        # Did it changed?
        if method("#{n}_changed?").call and not read_attribute(n).blank?
          activity.merge! points: 2, taxonomy: 'details', value: n
          # And save the activity
          Activity.find_or_create_by **activity
        end
      end
    end

    def fields_required
      [:birthdate, :birthplace, :education, :profession_category, :gender, :image]
    end

    def fields_completed
      fields_required.reduce 0 do |memo, field|
        memo + ( read_attribute(field).blank? ? 0 : 1 )
      end
    end

    def age
      unless birthdate.blank?
        Time.now.year - birthdate.year
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

    def assigned_to?(user)
      as_assignments.exists? user: user
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
