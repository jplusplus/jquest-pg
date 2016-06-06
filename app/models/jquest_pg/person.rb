module JquestPg
  class Person < ActiveRecord::Base
    has_paper_trail

    def display_name
      fullname
    end
  end
end
