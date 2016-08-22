module JquestPg
  class Legislature < ActiveRecord::Base

    include CsvAttributes

    has_many :mandatures, :dependent => :delete_all
    has_many :persons, through: :mandatures

    def self.csv_attributes
      %w{id name territory country start_date end_date number_of_members languages}
    end

    def languages
      # Not languages defined
      if read_attribute(:languages).blank? and country.present?
        ISO3166::Data.new(country).call['languages'] * ','
      else
        read_attribute(:languages)
      end
    end

    def format_params
       self.start_date = parse_year(start_date)
       self.end_date = parse_year(end_date)
    end

    def parse_year(date)
      # Allow casting of any valid value
      if date.kind_of? Integer and date.to_s.match /^(\d)+$/
        DateTime.new date.to_i
      else
        date
      end
    end

    def start_date
      # Not start_date defined
      if read_attribute(:start_date).blank?
        name_bounds.nil? ? nil : DateTime.new(name_bounds[0].to_i)
      else
        read_attribute(:start_date)
      end
    end

    def end_date
      # Not end_date defined
      if read_attribute(:end_date).blank?
        name_bounds.nil? ? nil : DateTime.new(name_bounds[1].to_i)
      else
        read_attribute(:end_date)
      end
    end

    def name_simplified
      name.gsub(/-\s(\d+)-(\d+)$/, '').strip
    end

    def name_bounds
      @name_bounds ||= /(\d+)-(\d+)/.match(name).to_a[1..-1]
    end

    def similars
      Legislature.
        # Exclude this legislature
        where.not(id: id).
        # Look for legislature with a similar name
        search(name_start: name_simplified, m: 'or', name_english_eq: name_english).
        # Returns the ActiveRecord relation
        result
    end

    def self.assignable_to(user)
      # Get user level
      level = user.points.find_or_create_by(season: user.member_of).level
      # Gets legislature for her level of progression
      legislatures = all
      # Different assignements according the level
      case level
      # LEVEL 1
      #   * legislature.difficulty_level is current level
      #   * legislature.end_date after the current year
      #   * legislature.country is user.home_country
      when 1
        # Some Filtering can be performed
        legislatures = legislatures.where difficulty_level: level
        legislatures = legislatures.where 'end_date >= ?', Date.today.year
        legislatures = legislatures.where country: user.home_country
      # LEVEL 2, 3
      #   * legislature.difficulty_level is current level
      #   * legislature.end_date after the current year
      #   * legislature.country is user.home_country
      #   * legislature.languages includes user.spoken_language
      when 2, 3
        # Some Filtering can be performed
        legislatures = legislatures.where difficulty_level: level
        legislatures = legislatures.where 'end_date >= ?', Date.today.year
        legislatures = legislatures.where country: user.home_country
        # Filter legislature that use the same language than the user
        legislatures = legislatures.select do |legislature|
          legislature.languages.split(',').map(&:strip).include? user.spoken_language
        end
      # LEVEL 4
      #   * legislature.difficulty_level is 1
      #   * legislature.end_date after the current year
      #   * legislature.country ISNT user.home_country
      #   * legislature.languages is 'en' or user.spoken_language
      when 4
        # Some Filtering can be performed
        legislatures = legislatures.where difficulty_level: 1
        legislatures = legislatures.where 'end_date >= ?', Date.today.year
        legislatures = legislatures.where.not country: user.home_country
        # Filter legislature that use a different language than the user
        legislatures = legislatures.select do |legislature|
          languages = legislature.languages.split(',').map(&:strip).to_set
          # True if 'en' or user.spoken_language are in languages
          languages.intersect? [user.spoken_language, 'en'].to_set
        end
      # LEVEL 5
      #   * legislature.difficulty_level is 1
      #   * legislature.end_date after the current year
      #   * legislature.country is not user.home_country
      #   * legislature.languages is not user.spoken_language and not 'en'
      when 5
        # Some Filtering can be performed
        legislatures = legislatures.where difficulty_level: 1
        legislatures = legislatures.where 'end_date >= ?', Date.today.year
        legislatures = legislatures.where.not country: user.home_country
        # Filter legislature that use a different language than the user and not 'en'
        legislatures = legislatures.select do |legislature|
          languages = legislature.languages.split(',').map(&:strip)
          not languages.include? 'en' and not languages.include? user.spoken_language
        end
      # LEVEL 6
      #   * legislature.difficulty_level is 1
      #   * legislature.end_date before the current year
      #   * legislature.end_date after 50 years ago
      #   * legislature.country is user.home_country
      #   * legislature.languages includes user.spoken_language
      when 6
        # Some Filtering can be performed
        legislatures = legislatures.where difficulty_level: 1
        legislatures = legislatures.where 'end_date <  ?', Date.today.year
        legislatures = legislatures.where 'end_date >= ?',  30.years.ago
        legislatures = legislatures.where country: user.home_country
        # Filter legislature that use the same language than the user
        legislatures = legislatures.select do |legislature|
          legislature.languages.split(',').map(&:strip).include? user.spoken_language
        end
      # LEVEL 7
      #   * legislature.difficulty_level is 1
      #   * legislature.end_date before 50 years ago
      #   * legislature.languages is user.spoken_language or 'en'
      when 7
        # Some Filtering can be performed
        legislatures = legislatures.where difficulty_level: 1
        legislatures = legislatures.where 'end_date < ?', 30.years.ago
        # Filter legislature that use the same language than the user or 'en'
        legislatures = legislatures.select do |legislature|
          languages = legislature.languages.split(',').map(&:strip)
          languages.include? 'en' or languages.include? user.spoken_language
        end
      else
        # Unkownm level, no legislatures
        legislatures = legislatures.none
      end
      # Returns all assignable legislatures
      legislatures
    end
  end
end
