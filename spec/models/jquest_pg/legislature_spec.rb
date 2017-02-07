require 'rails_helper'

module JquestPg
  RSpec.describe Legislature, type: :model do

    it "has one" do
      Legislature.create
      expect(Legislature.count).to eq 1
    end

    it "has one with a language related to its country" do
      Legislature.create country: 'FR'
      expect(Legislature.first.languages).to eq 'fr'
      Legislature.create country: 'BE'
      expect(Legislature.first.languages).to eq 'fr'
    end

  end
end
