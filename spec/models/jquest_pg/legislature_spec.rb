require 'rails_helper'

module JquestPg
  RSpec.describe Legislature, type: :model do
    it "has one" do
      Legislature.create
      expect(Legislature.count).to eq 1
    end
  end
end
