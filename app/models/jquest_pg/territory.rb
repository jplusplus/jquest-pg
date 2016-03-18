module JquestPg
  class Territory < ActiveRecord::Base
    def display_name
      name
    end
  end
end
