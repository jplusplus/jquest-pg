module JquestPg
  class Legislature < ActiveRecord::Base
    def languages
      @languages = read_attribute(:languages)
      if (not @languages or @languages == '') and country
        @languages = ISO3166::Data.new(country).call['languages'] * ','
      end
      @languages
    end
  end
end
