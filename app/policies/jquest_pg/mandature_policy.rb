module JquestPg
  class MandaturePolicy < AdminPolicy

    attr_reader :user, :model

    def permitted_attributes
      if @user.role? :teacher, :admin
        [ :legislature_id, :person_id, :political_leaning,
          :role, :group, :area, :chamber ]
      else
        # Get columns names
        names = JquestPg::Mandature.columns.map(&:name)
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
      create? or @model.assigned_to? @user
    end

    def restore?
      create?
    end

    def restore_all?
      restore?
    end

    def round_up?
      @model.pending_and_assigned_to?(@user) and progression.remaining <= 0
    end

  end
end
