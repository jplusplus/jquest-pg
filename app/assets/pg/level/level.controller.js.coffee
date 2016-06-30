angular.module 'jquest'
  .controller 'MainSeasonPgLevelCtrl', (people, mandatures, seasons, $state, SETTINGS, $scope)->
    'ngInject'
    new class MainSeasonPgLevelCtrl
      # Assignements are always the same during a level
      people: people
      mandatures: mandatures
      # Method to start a round
      startRound: =>
        progression = seasons.current().progression
        # Bind level's properties to
        angular.extend @, SETTINGS.LEVELS[progression.level - 1]
        # Always redirect to the current level and round
        $state.go 'main.season.pg.level.round', progression
      constructor: ->
        # Start the round
        do @startRound
        # Start again if the progression changed
        $scope.$on 'progression:changed', (ev, changed)=>
          # Level changed
          if changed[0] then $state.go 'main.season.pg'
          # Round changed
          else do @startRound
