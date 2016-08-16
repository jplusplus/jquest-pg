angular.module 'jquest'
  .controller 'MainSeasonPgRepresentativesCtrl', (assignments)->
    'ngInject'
    new class MainSeasonPgRepresentativesCtrl
      constructor: ->
        # Group Assignment by level
        @levels = _.groupBy assignments, 'level'
        @levels = _.toPairs @levels
        # Sort levels by their number
        @levels = _.sortBy @levels, (l)=> l[0]
