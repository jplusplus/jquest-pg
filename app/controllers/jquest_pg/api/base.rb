require "garner/mixins/rack"

module JquestPg
  module API
    class Base < Grape::API
      # Inherit from jQuest API helpers
      helpers ::API::AuthenticableHelpers
      helpers Garner::Mixins::Rack

      helpers do
        def progression
          JquestPg::ApplicationController.new.progression current_user
        end

        def season
          Season.find_by engine_name: JquestPg.name
        end

        def current_user_point
          current_user.points.find_by(season: season)
        end

        # Calculate the median of the given array
        def median(array)
          sorted = array.sort
          len = sorted.length
          (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
        end
      end

      before do
        # Allow us to track change on model
        PaperTrail.whodunnit = current_user.id unless current_user.nil?
      end

      mount V1::Base
    end
  end
end
