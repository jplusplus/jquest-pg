module JquestPg
  class ApplicationController < SeasonController

    def index
      render 'jquest_pg/index', :layout => 'layouts/application'
    end

    def season
      @season ||= Season.find_or_create_by engine_name: JquestPg.name
    end

    def new_assignments!(user)
      # Get user progression
      @progression = progression user, season
      # Did we have enought assignments for this level
      if user.assignments.where(level: @progression.level, season: season).count() < Mandature::MAX_ASSIGNABLE
        # Find new assignments
        Mandature::assigned_to user, season, true, :pending
      end
    end

    def progression(user, season=user.member_of)
      activities = season.activities.where(user: user).where.not(assignment: nil)
      # Find or create Point instance for this season
      point = user.points.find_or_create_by(season: season)
      # Ensure user has mandature assigned to her
      Mandature.assigned_to(user, season, true, :pending)
      # Determine the current taxonomy according to the round
      round_taxonomies = { 1 => 'genderize', 2 => 'details', 3 => 'diversity' }
      round_taxonomy = round_taxonomies[point.round]
      # Find the user finished assignements for the current round's taxonomy
      fids = activities.where(taxonomy: round_taxonomy).distinct.pluck(:assignment_id)
      # Get the remaining assignments.
      # Reamaing assignment are the one that have no activity yet.
      remaining = user.assignments.order(:resource_id).pending.where.not(id: fids).order(:id)
      # Return a simple hash
      OpenStruct.new level: point.level,
                     round: point.round,
                     points: point.value,
                     position: point.position,
                     # Remaining assignments count
                     remaining: remaining.length
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
      remaining = user.assignments.where.not(id: fids).order(:id)
      # Current assignment is the first of the remaining
      assignment = remaining.first
      # Get user points
      points = user.points.find_or_create_by season: season
      # Return a simple hash
      OpenStruct.new level: level,
                     round: round,
                     points: points.value,
                     position: points.position,
                     # Remaining assignments count
                     remaining: remaining.length,
                     # Return it as JSON resolving the nested resources
                     assignment: assignment
    end
  end
end
