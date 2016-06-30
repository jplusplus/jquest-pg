module JquestPg
  class ApplicationController < SeasonController

    def index
      render 'jquest_pg/index', :layout => 'layouts/application'
    end

    def progression(user, season=user.member_of)
      activities = user.activities.where(season: season).where.not(assignment: nil)
      # Determines the level counting the number of assignment (6 new for each level)
      level = [1, user.assignments.where(season: season).count()/6.to_i].max
      # Determines the round according to the number of distinct assignments
      round = activities.group(:taxonomy, :assignment_id).count().length/6 + 1
      # Determine the current taxonomy according to the round
      round_taxonomies = { 1 => 'genderize', 2 => 'details', 3 => 'diversity' }
      round_taxonomy = round_taxonomies[round]
      # Find the user finished assignements for the current round's taxonomy
      fids = activities.where(taxonomy: round_taxonomy).distinct.pluck(:assignment_id)
      # Get the remaining assignments
      remaining_assignments = user.assignments.where.not(id: fids).order(:id)
      # Current assignment is the first of the remaining
      assignment = remaining_assignments.first
      # Return a simple hash
      OpenStruct.new level: level,
                     round: round,
                     points: user.season_points(season),
                     # Remaining assignments count
                     remaining_assignments: remaining_assignments.length,
                     # Return it as JSON resolving the nested resources
                     assignment: assignment
    end
  end
end
