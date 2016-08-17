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
      # Did we have enought assignments for this level?      
      if user.assignments.where(level: @progression.level, season: season).count() < Mandature::MAX_ASSIGNABLE
        # Find new assignments
        Mandature::assign_to! user, season
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
  end
end
