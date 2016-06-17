angular.module 'jquest'
  .controller 'MainSeasonPgLevelRoundCtrl', (assignements, seasons, $state, $stateParams)->
    'ngInject'
    new class MainSeasonPgLevelRoundCtrl
      title: "Round #{seasons.current().progression.round}"
      # Find the currency assignment according to the user activity
      isCurrentAssingnment: (a)->
        seasons.current().progression.assignment?.resource_id is a.id
      # Redirect to a child state according to the current round
      constructor: ->
        switch parseInt($stateParams.round)
          when 1 then $state.go 'main.season.pg.level.round.gender'
          when 2 then $state.go 'main.season.pg.level.round.detail'
          when 3 then $state.go 'main.season.pg.level.round.diversity'
