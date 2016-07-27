angular.module 'jquest'
  .controller 'MainSeasonPgLevelRoundDetailsCtrl', ($state, mandature, seasons)->
    'ngInject'
    new class MainSeasonPgLevelRoundDetailsCtrl
      mandature: mandature
      finally: =>
        # Reload progression after both promises have be resolved
        seasons.reload().then ->
          # Still on this round
          if seasons.current().progression.round is 2
            # Once the season is reloaded, we might refresh the current round
            $state.go 'main.season.pg.level.round', seasons.current().progression
          # A new level started!
          else
            # Go back to the summary screen
            $state.go 'main.season.pg.level.round.details.summary'
