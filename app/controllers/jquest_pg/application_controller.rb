module JquestPg
  class ApplicationController < SeasonController
    def index
      render 'jquest_pg/index', :layout => 'layouts/application'
    end

    def progression(user, season=user.member_of)
      activities = user.activities.where season: season
      # Get the higher level the user finished: we are now to the next level
      level = activities.where(taxonomy: "level:finish").maximum(:value).to_i + 1
      # Get the higher round current level: we are now to the next level
      round = activities.where(taxonomy: "level:#{level}:round:finished").maximum(:value).to_i + 1
      # Find the user finished assignements
      fids = activities.where(taxonomy: "level:#{level}:round:#{round}:task:finished").map(&:value)
      # Get the remaining assignments
      remaining_assignments = user.assignments.where.not(id: fids).order(:id)
      # Current assignment is the first of the remaining
      assignment = remaining_assignments.first
      # Return a simple hash
      {
        level: level,
        round: round,
        points: user.season_points(season),
        # Remaining assignments count
        remaining_assignments: remaining_assignments.length,
        # Return it as JSON resolving the nested resources
        assignment: assignment.as_json(
          include: {
            resource: {
              include: [:person, :legislature]
            }
          }
        )
      }
    end
  end
end
