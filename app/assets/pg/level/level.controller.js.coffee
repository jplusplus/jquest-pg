angular.module 'jquest'
  .controller 'MainSeasonPgLevelCtrl', (people, mandatures, seasons, $state, $stateParams, SETTINGS, $scope)->
    'ngInject'
    new class MainSeasonPgLevelCtrl
      # Assignements are always the same during a level
      people: people
      mandatures: mandatures
      # Method to start a round
      startRound: =>
        console.log $stateParams
        progression = seasons.current().progression
        # Find the level description with the parent controller
        level = $scope.$parent.pg.getLevels()[ progression.level - 1 ]
        # Bind level's properties to
        angular.extend @, level
        # Always redirect to the current level and round
        $state.go 'main.season.pg.level.round', $stateParams, reload: 'main.season.pg.level.round'
      constructor: ->
        # Start the round
        do @startRound
