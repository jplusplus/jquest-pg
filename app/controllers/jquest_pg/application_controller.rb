module JquestPg
  class ApplicationController < SeasonController

    def index
      render 'jquest_pg/index', :layout => 'layouts/application'
    end

    def new_assignments!(user, season=user.member_of)
      # Mark all pending assignments as done
      user.assignments.pending.where(season: season).update_all status: :done
      # Find new assignments
      Mandature::assigned_to user, season, true, :pending
    end

    def progression(user, season=user.member_of)
      activities = user.activities.where(season: season).where.not(assignment: nil)
      # Find or create Point instance for this season
      point = user.points.find_or_create_by(season: season)
      # Determine the current taxonomy according to the round
      round_taxonomies = { 1 => 'genderize', 2 => 'details', 3 => 'diversity' }
      round_taxonomy = round_taxonomies[point.round]
      # Find the user finished assignements for the current round's taxonomy
      fids = activities.where(taxonomy: round_taxonomy).distinct.pluck(:assignment_id)
      # Get the remaining assignments
      remaining_assignments = user.assignments.where.not(id: fids).order(:id)
      # Current assignment is the first of the remaining
      assignment = remaining_assignments.first
      # Return a simple hash
      OpenStruct.new level: point.level,
                     round: point.round,
                     points: point.value,
                     position: point.position,
                     # Remaining assignments count
                     remaining_assignments: remaining_assignments.length,
                     # Return it as JSON resolving the nested resources
                     assignment: assignment
    end

    def progression_legacy(user, season=user.member_of)
      activities = user.activities.where(season: season).where.not(assignment: nil)
      # Number of processed assignment deduced from the number of activity (one by assignment in a given taxonomy)
      processed = activities.group(:taxonomy, :assignment_id).count().length
      # Determines the level according to the number of processed assignments
      level = [1, processed / (6*3) + 1].max
      # Determines the round according to the number of processed assignments
      round = [1, processed / 6 % 3 + 1].max
      # Determine the current taxonomy according to the round
      round_taxonomies = { 1 => 'genderize', 2 => 'details', 3 => 'diversity' }
      round_taxonomy = round_taxonomies[round]
      # Find the user finished assignements for the current round's taxonomy
      fids = activities.where(taxonomy: round_taxonomy).distinct.pluck(:assignment_id)
      # Get the remaining assignments
      remaining_assignments = user.assignments.where.not(id: fids).order(:id)
      # Current assignment is the first of the remaining
      assignment = remaining_assignments.first
      # Get user points
      points = user.points.find_or_create_by season: season
      # Return a simple hash
      OpenStruct.new level: level,
                     round: round,
                     points: points.value,
                     position: points.position,
                     # Remaining assignments count
                     remaining_assignments: remaining_assignments.length,
                     # Return it as JSON resolving the nested resources
                     assignment: assignment
    end
  end
end
