angular.module 'jquest'
  .controller 'MainSeasonPgLevelCtrl', (assignements, seasons, $state, LEVELS)->
    'ngInject'
    new class MainSeasonPgLevelCtrl
      assignements: assignements
      constructor: ->
        progression = seasons.current().progression
        # Bind level's properties to
        angular.extend @, LEVELS[progression.level + 1]
        # Always redirect to the current level and round
        $state.transitionTo 'main.season.pg.level.round', progression
