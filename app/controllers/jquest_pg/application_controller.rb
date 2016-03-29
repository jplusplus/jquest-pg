module JquestPg
  class ApplicationController < ActionController::Base
    def index
      render 'jquest_pg/index', :layout => 'layouts/application'
    end
  end
end
