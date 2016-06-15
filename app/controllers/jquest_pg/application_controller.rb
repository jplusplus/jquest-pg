module JquestPg
  class ApplicationController < SeasonController
    def index
      render 'jquest_pg/index', :layout => 'layouts/application'
    end

    def progression(user=nil)
      {
        level: 1,
        round: 1,
        user_id: user ? user.id : nil
      }
    end
  end
end
