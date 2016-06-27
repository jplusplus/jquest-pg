module JquestPg
  class MandaturePolicy < AdminPolicy

    attr_reader :user, :model

    def permitted_attributes
      if @user.role? :teacher, :admin
        [ :legislature_id, :person_id, :political_leaning,
          :role, :group, :area, :chamber ]
      elsif progression[:round] == 2
        # Get columns names
        names = JquestPg::Manature.columns.map(&:name)
        # Filter non empty ones and return symbols
        names.select{ |name| @model[name].blank? }.map(&:to_sym)
      end
    end

    def initialize(user, model)
      @user = user
      @model = model
    end

    def progression
      @progression ||= JquestPg::ApplicationController.new.progression @user
    end

    def index?
      true
    end

    def show?
      true
    end

    def update?
      create? or Mandature.find(progression[:assignment]["resource_id"]).person == @model
    end
  end
end
