angular.module 'jquest'
  .controller 'MainSeasonPgLevelCtrl', (assignements, progression, $state)->
    'ngInject'
    new class MainSeasonPgLevelCtrl
      assignements: assignements
      constructor: ->
        # Always redirect to the current round
        $state.transitionTo 'main.season.pg.level.round', progression
