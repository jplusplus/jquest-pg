module JquestPg
  module API
    module V1
      class Mandatures < Grape::API

        helpers do
          def topics_count_by
            {
              gender:              "#{Person.table_name}.gender",
              political_leaning:   "#{Mandature.table_name}.political_leaning",
              profession_category: "#{Person.table_name}.profession_category",
              age_range:           "#{Mandature.table_name}.age_range",
            }
          end

          def summary_by_topic(mandatures, topic)
            ages = []
            # Joined to legislature and person
            mandatures.joined.
              # We need the birthdate
              where("#{Person.table_name}.birthdate IS NOT NULL").
              # Select only some fields
              select(["#{Mandature.table_name}.id",
                      "#{Mandature.table_name}.legislature_id",
                      "#{Mandature.table_name}.person_id",
                      "#{Legislature.table_name}.start_date AS lsd",
                      "#{Person.table_name}.birthdate AS pbd"]).
              # Avoid loading every activerecord in  memory
              find_each do |mandature|
                ages << mandature.lsd.to_date.year - mandature.pbd.to_date.year
              end
            # Returns a hash
            summary = {
              total: mandatures.count,
              age: {
                min: ages.empty? ? nil : ages.min,
                max: ages.empty? ? nil : ages.max,
                median: ages.empty? ? nil : median(ages)
              }
            }
            # Add all topic if none is specified
            if topic == 'all'
              topics_count_by.each do |topic, count_by|
                summary[topic] = mandatures.count_by count_by
              end
            # A topic is selected
            elsif not topic.nil? and not topics_count_by[topic.to_sym].nil?
              # Only one topic is added to the result
              summary[topic] = mandatures.count_by topics_count_by[topic.to_sym]
            end
            # Return the new summary
            summary
          end
        end

        resource :mandatures do
          desc "Return list of mandatures"
          params do
            optional :limit, type: Integer, default: 25
            optional :legislature_id_eq, type: Integer
            optional :legislature_country_eq, type: String
            optional :legislature_territory_cont, type: String
            optional :person_fullname_or_legislature_name_cont, type: String
          end
          paginate max_per_page: 5000
          get do
            # Paginate result
            paginate policy_scope(Mandature).
              # We allow filtering
              search(declared params).
              result.
              # Join to related tables
              eager_load(:person).
              eager_load(:legislature).
              # Sort by id
              order(:id)
          end

          desc "Return summary about all mandatures"
          params do
            optional :legislature_id_eq, type: Integer
            optional :legislature_country_eq, type: String
            optional :topic, type: String, default: 'none', values: ['all', 'gender', 'political_leaning', 'profession_category', 'age_range', 'none']
          end
          get :summary do
            # Topic selected by the user
            topic = declared(params).topic
            # Is current user authenticated?
            if current_user
              assigned = Mandature.includes(:legislature).includes(:person).
                # Mandatures assigned to the user
                assigned_to(current_user, season, false, :pending)
            else
              assigned = Mandature.none
            end
            # All unfinished mandatures
            global = policy_scope(Mandature).search(declared params).result.unfinished
            # Create a hash of values for the two subsets
            {
              # The 'global' summary might be cached
              global: Rails.cache.fetch("mandatures/summary/#{topic}", expires_in: 1.days) do
                summary_by_topic(global, topic)
              end,
              # The 'assgined' isn't
              assigned: summary_by_topic(assigned, topic)
            }
          end

          resource :assigned do
            desc "Return list of mandatures assigned to the user"
            paginate
            get each_serializer: MandatureSerializer, include_sources: true do
              authenticate!
              # Collect mandature assigned to this user
              paginate Mandature.assigned_to(current_user, current_user.member_of, true).
                # Join to related tables
                eager_load(:person).
                eager_load(:legislature).
                # Load sources
                includes(person: :sources).
                includes(:sources).
                # Sort by id
                order(:id)
            end

            desc "Return list of mandatures assigned to the user and still pending"
            paginate
            get :pending, each_serializer: MandatureSerializer, include_sources: true do
              authenticate!
              # Collect mandature assigned to this user
              paginate Mandature.assigned_to(current_user, current_user.member_of, true, :pending).
                # Join to related tables
                eager_load(:person).
                eager_load(:legislature).
                # Load sources
                includes(person: :sources).
                includes(:sources).
                # Sort by id
                order(:id)
            end


            desc "Return list of mandatures assigned to the user and done"
            paginate
            get :done, each_serializer: MandatureSerializer, include_sources: true  do
              authenticate!
              # Collect mandature assigned to this user
              paginate Mandature.assigned_to(current_user, current_user.member_of, true, :done).
                # Join to related tables
                eager_load(:person).
                eager_load(:legislature).
                # Load sources
                includes(person: :sources).
                includes(:sources).
                # Sort by id
                order(:id)
            end
          end

          params do
            requires :id, type: Integer, desc: 'mandature id'
          end
          route_param :id do

            desc "Get a mandature"
            get serializer: MandatureSerializer, include_sources: true do
              Mandature.find(params[:id])
            end

            desc "Update a mandature"
            put do
              authenticate!
              mandature = Mandature.find params[:id]
              # The mandature must be assigned to that user's progression
              authorize mandature, :update?
              # Create or update sources
              params[:sources].map! do |source|
                source.resource = mandature
                Source.update_or_create source
              end
              mandature.update_attributes permitted_params(mandature, params)
              # Could this mandature lead us to the next round?
              if MandaturePolicy.new(current_user, mandature).round_up?
                # Go to the next round
                current_user_point.next_round
              end
              # Return a mandature
              mandature
            end

            desc "Skip a mandature"
            put :skip do
              authenticate!
              mandature = Mandature.find params[:id]
              # The mandature must be assigned to that user's progression
              authorize mandature, :update?
              # Add an activity saying we skip this mandature
              mandature.skipped_by current_user
              # Could this mandature lead us to the next round?
              if MandaturePolicy.new(current_user, mandature).round_up?
                # Go to the next round
                current_user_point.next_round
              end
              # Return a mandature
              mandature
            end
          end

        end
      end
    end
  end
end
