module JquestPg
  class Mandature < ActiveRecord::Base
    belongs_to :legislature
    belongs_to :person
  end
end
