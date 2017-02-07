require 'rails_helper'

module JquestPg
  RSpec.describe Mandature, type: :model do

    it "has none" do
      Mandature.create
      expect(Mandature.count).to eq 0
    end

    it "has one" do
      # A mandature bounds a person to a legislature
      Mandature.create! person: create(:person), legislature: create(:legislature)
      expect(Mandature.count).to eq 1
    end

    it "has one using factory" do
      # Another mandature created with a factory
      create :mandature
      expect(Mandature.count).to eq 1
    end

    it "can assign someone twice to the same user in the same level" do
      # Create 1 user
      user = create :user, :firstname => "Tom", :lastname => "Waits"
      # Create 5 mandatures for 5 different people in the same legislature
      create_list :mandature, 5, legislature: create(:legislature)
      # Add a 6th mandature for an existing person in a new legislature
      create :mandature, person: Person.first, legislature: create(:legislature)
      # There is now 6 mandatures
      expect(Mandature.count).to eq 6
      # There is now 5 people
      expect(Person.count).to eq 5
      # There is now 2 legislature
      expect(Legislature.count).to eq 2
      # There should be 2 legislatures than can be assogned to the user
      expect(Legislature.assignable_to(user).count).to eq 2
      # We assign mandature to the user now
      Mandature.assign_to! user
      # Only 5 people must be assigned to the user
      expect(user.assignments.pending.count).to eq 5
    end

    it "can assign someone twice to the same user" do
      # Create 1 user
      user = create :user, :firstname => "Tom", :lastname => "Waits"
      # Create 5 mandatures for 5 different people in the same legislature
      create_list :mandature, 5, legislature: create(:legislature)
      # Create a legislature for level 2
      legislature = create(:legislature, difficulty_level: 2, end_date: Date.tomorrow)
      # Add a 6th mandature for an existing person in the next legislature
      create :mandature, person: Person.first, legislature: legislature
      # Add a 7th mandature for a new person in the next legislature
      create :mandature, person: create(:person), legislature: legislature
      # We assign mandature to the user now
      Mandature.assign_to! user
      # Only 5 people must be assigned to the user
      expect(user.assignments.pending.count).to eq 5
      # Go to the next level
      user.points.first.next_level
      # Only 1 legislature can be assigned to the user
      expect(Legislature.assignable_to(user).count).to eq 1
      # Only 1 people must be assigned to the user
      expect(user.assignments.pending.count).to eq 1
    end
  end
end
