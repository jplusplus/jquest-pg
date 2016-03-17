module JquestPg
  class Territory < ActiveRecord::Base
    def to_s
      name
    end
  end
end
