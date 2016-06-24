angular.module 'jquest'
  .controller 'MainSeasonPgLevelRoundCtrl', (seasons, mandature, person, $state)->
    'ngInject'
    new class MainSeasonPgLevelRoundCtrl
      title: "Round #{seasons.current().progression.round}"
      person: person
      mandature: mandature
      # Find the currency assignment according to the user activity
      isCurrentAssignment: (manddature)->
        seasons.current().progression.assignment?.resource_id is manddature.id
      getCurrentAssignment: ->
        seasons.current().progression.assignment
      # Redirect to a child state according to the current round
      constructor: ->
        switch seasons.current().progression.round
          when 1 then $state.go 'main.season.pg.level.round.gender'
          when 2 then $state.go 'main.season.pg.level.round.details'
          when 3 then $state.go 'main.season.pg.level.round.diversity'
