module JquestPg
  class ApplicationController < ActionController::Base
    def index
      render 'layouts/jquest_pg/application', layout: false
    end
  end
end
