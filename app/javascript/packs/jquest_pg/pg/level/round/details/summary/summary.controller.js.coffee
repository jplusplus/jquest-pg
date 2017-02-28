angular.module 'jquest'
  .controller 'MainSeasonPgLevelRoundDetailsSummaryCtrl', (summary)->
    'ngInject'
    new class MainSeasonPgLevelRoundDetailsSummaryCtrl
      global: summary.global
      assigned: summary.assigned
      medianStyle: (median)->
        # Bounds
        min = 0 # Math.min(@global.age.min, @assigned.age.min)
        max = 90 # Math.max(@global.age.max, @assigned.age.max)
        # Get bar position
        top: 100 - (median - min)/(max - min) * 100 + '%'
