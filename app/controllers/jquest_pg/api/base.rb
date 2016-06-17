module JquestPg
  module API
    # Inherit from jQuest API Base
    class Base < Grape::API
      helpers ::API::AuthenticableHelpers

      helpers do
        def progression
          JquestPg::ApplicationController.new.progression current_user
        end
      end

      before do
        # Allow us to track change on model
        PaperTrail.whodunnit = current_user.id
      end

      mount V1::Base
    end
  end
end
