module JquestPg
  module API
    module V1
      class Persons < Grape::API
        resource :persons do
          desc "Return list of persons"
          get do
            Person.page(params[:page])
          end

          desc "Return list of persons assigned to the user"
          get :assigned do
            authenticate!
            # Collect person assigned to this user
            persons = Person.assigned_to current_user
            # The user may not have assigned person yet
            if persons.length == 0
              # Assign person to the user
              persons = Person.assign_to! current_user
            end
            # And returns persons list
            persons
          end
        end
      end
    end
  end
end
