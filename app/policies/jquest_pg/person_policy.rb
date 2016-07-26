module JquestPg
  class PersonPolicy < AdminPolicy

    attr_reader :user, :model


    def permitted_attributes
      if @user.role? :teacher, :admin
        [ :fullname, :firstname, :lastname, :email, :education,
          :profession_category, :profession, :image, :twitter, :facebook,
          :gender, :birthdate, :birthplace, :phone ]
      elsif progression[:round] == 1
        [:gender]
      else
        # Get columns names
        names = JquestPg::Person.columns.map(&:name)
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
  end
end
