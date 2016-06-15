module JquestPg
  class Legislature < ActiveRecord::Base

    before_validation :format_params

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

    def name_bounds
      @name_bounds ||= /(\d+)-(\d+)/.match(name).to_a[1..-1]
    end
  end
end
