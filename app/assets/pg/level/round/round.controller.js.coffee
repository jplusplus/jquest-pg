angular.module 'jquest'
  .controller 'MainSeasonPgLevelRoundCtrl', (assignements, $state, $stateParams)->
    'ngInject'
    new class MainSeasonPgLevelRoundCtrl
      constructor: ->
        switch parseInt($stateParams.round)
          when 1 then $state.go 'main.season.pg.level.round.gender'
          when 2 then $state.go 'main.season.pg.level.round.detail'
          when 3 then $state.go 'main.season.pg.level.round.diversity'
