module JquestPg
  class ApplicationController < SeasonController
    def index
      render 'jquest_pg/index', :layout => 'layouts/application'
    end

    def progression(user)
      activities = user.activities.where season: season
      # Get the higher level the user finished: we are now to the next level
      level = activities.where(taxonomy: 'LEVEL:FINISH').maximum(:value).to_i + 1
      # Get the higher round current level: we are now to the next level
      round = activities.where(taxonomy: 'LEVEL:#{level}:ROUND:FINISH').maximum(:value).to_i + 1
      # Return a simple hash
      { level: level, round: round }
    end
  end
end
