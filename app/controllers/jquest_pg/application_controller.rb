module JquestPg
  class ApplicationController < SeasonController

    def index
      render 'jquest_pg/index', :layout => 'layouts/application'
    end

    def season
      @season ||= Season.find_or_create_by engine_name: JquestPg.name
    end

    def new_assignments!(user)
      level = user.points.find_or_create_by(season: season).level
      missing_assignments = Mandature::missing_assignments user, season, level
      # Did we have enought assignments for this level?
      if missing_assignments > 0
        # Find new assignments
        Mandature::assign_to! user, season
      # Too many assignments?
      elsif missing_assignments < 0
        # Targes assignments to remove, beyond the maximum we can assign
        user.assignments.where(season: season, level: level).offset(Mandature::MAX_ASSIGNABLE).each do |assignment|
          # Delete the assignment!
          assignment.delete
        end
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
