module JquestPg
  class ApplicationController < SeasonController
    def index
      render 'jquest_pg/index', :layout => 'layouts/application'
    end

    def progression(user, season=user.member_of)
      activities = user.activities.where season: season
      # Get the higher level the user finished: we are now to the next level
      level = activities.where(taxonomy: "LEVEL:FINISH").maximum(:value).to_i + 1
      # Get the higher round current level: we are now to the next level
      round = activities.where(taxonomy: "LEVEL:#{level}:ROUND:FINISHED").maximum(:value).to_i + 1
      # Find the user finished assignements
      fids = activities.where(taxonomy: "LEVEL:#{level}:ROUND:#{round}:TASK:FINISHED").map(&:value)
      # Return a simple hash
      {
        level: level,
        round: round,
        assignment: user.assignments.where.not(id: fids).first
      }
    end
  end
end
