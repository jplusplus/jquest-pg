angular.module 'jquest'
  .controller 'MainSeasonPgCtrl', (seasons, $state)->
    'ngInject'
    new class MainSeasonPgCtrl
      constructor: ->
        # Get activities for the current season
        seasons.activities().then (activities)->
          # Look for the 'INTRO'
          unless _.find(activities, taxonomy: 'INTRO')
            # Redirect to the tutorial for this season
            $state.go 'main.season.pg.intro'
