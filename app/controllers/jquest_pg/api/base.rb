module JquestPg
  module API
    # Inherit from jQuest API Base
    class Base < Grape::API
      helpers ::API::AuthenticableHelpers
      mount V1::Base
    end
  end
end
