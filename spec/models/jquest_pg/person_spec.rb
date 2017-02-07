require 'rails_helper'

module JquestPg
  RSpec.describe Person, type: :model do
    it "has one" do
      Person.create
      expect(Person.count).to eq 1
    end
  end
end
