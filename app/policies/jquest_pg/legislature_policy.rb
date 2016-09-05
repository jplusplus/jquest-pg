module JquestPg
  class LegislaturePolicy < AdminPolicy

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
  end
end
