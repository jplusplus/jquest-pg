module JquestPg
  class DiversityPolicy < AdminPolicy

    attr_reader :user, :model

    def initialize(user, model)
      @user = user
      @model = model
    end

    def index?
      true
    end

    def show?
      true
    end

    def level_up?
      # One of the two nested people must allow us to round up
      PersonPolicy.new(@user, @model.resource_b).round_up? or \
      PersonPolicy.new(@user, @model.resource_a).round_up?
    end
  end
end
