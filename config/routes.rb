JquestPg::Engine.routes.draw do
  # You can have the root of your site routed with "root"
  get '/', to: 'application#index'
  # Activate API
  mount JquestPg::API::Base => '/api'
end
