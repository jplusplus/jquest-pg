module JquestPg
  class Diversity < ActiveRecord::Base

    belongs_to :resource_a, polymorphic: true
    belongs_to :resource_b, polymorphic: true

    def self.types
      ActiveRecord::Base.send(:subclasses).map(&:name)
    end
  end
end
