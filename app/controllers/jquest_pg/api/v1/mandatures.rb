module JquestPg
  module API
    module V1
      class Mandatures < Grape::API

        helpers do
          def topics_count_by
            {
              gender: 'person.gender',
              political_leaning: 'political_leaning',
              profession_category: 'person.profession_category',
              age_range: 'age_range',
            }
          end

          def summary_by_topic(mandatures, topic)
            # Age values at tehe begin of the legislature
            ages = mandatures.map(&:age).compact
            # Returns a hash
            summary = {
              total: mandatures.length,
              age: {
                min: ages.empty? ? nil : ages.min,
                max: ages.empty? ? nil : ages.max,
                median: ages.empty? ? nil : median(ages)
              }
            }
            # Add all topic if none is specified
            if topic.nil?
              topics_count_by.each do |topic, count_by|
                summary[topic] = mandatures.count_by count_by
              end
            # A topic is selected
            else
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
            optional :legislature_id_eq, type: Integer
            optional :legislature_country_eq, type: String
            optional :legislature_territory_cont, type: String
            optional :person_fullname_or_legislature_name_cont, type: String
          end
          get do
            policy_scope(Mandature).
              # We allow filtering
              search(declared params).
              result.
              # Join to related tables
              eager_load(:person).
              eager_load(:legislature).
              # Sort by id
              order(:id).
              # Paginates results
              page(params[:page]).
              # Default limit is 25
              per(params[:limit])
          end


          desc "Return summary about all mandatures"
          params do
            optional :legislature_id_eq, type: Integer
            optional :legislature_country_eq, type: String
            optional :topic, type: String, values: ['gender', 'political_leaning', 'profession_category', 'age_range']
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
              global: Rails.cache.fetch('mandatures/summary/global', expires_in: 60.minutes) do
                summary_by_topic(global, topic)
              end,
              # The 'assgined' isn't
              assigned: summary_by_topic(assigned, topic)
            }
          end

          resource :assigned do
            desc "Return list of mandatures assigned to the user"
            get each_serializer: MandatureSerializer, include_sources: true do
              authenticate!
              # Collect mandature assigned to this user
              Mandature.assigned_to(current_user, current_user.member_of, true).
                # Join to related tables
                eager_load(:person).
                eager_load(:legislature).
                # Load sources
                includes(person: :sources).
                includes(:sources).
                # Sort by id
                order(:id).
                # Paginates results
                page(params[:page]).
                # Default limit is 25
                per(params[:limit])
            end

            desc "Return list of mandatures assigned to the user and still pending"
            get :pending, each_serializer: MandatureSerializer, include_sources: true do
              authenticate!
              # Collect mandature assigned to this user
              Mandature.assigned_to(current_user, current_user.member_of, true, :pending).
                # Join to related tables
                eager_load(:person).
                eager_load(:legislature).
                # Load sources
                includes(person: :sources).
                includes(:sources).
                # Sort by id
                order(:id).
                # Paginates results
                page(params[:page]).
                # Default limit is 25
                per(params[:limit])
            end


            desc "Return list of mandatures assigned to the user and done"
            get :done, each_serializer: MandatureSerializer, include_sources: true  do
              authenticate!
              # Collect mandature assigned to this user
              Mandature.assigned_to(current_user, current_user.member_of, true, :done).
                # Join to related tables
                eager_load(:person).
                eager_load(:legislature).
                # Load sources
                includes(person: :sources).
                includes(:sources).
                # Sort by id
                order(:id).
                # Paginates results
                page(params[:page]).
                # Default limit is 25
                per(params[:limit])
            end
          end

          params do
            requires :id, type: Integer, desc: 'mandature id'
          end
          route_param :id do

            desc "Get a mandature"
            get do
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
