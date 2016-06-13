angular.module 'jquest'
  .controller 'MainSeasonPgCtrl', (seasons, $state)->
    'ngInject'
    new class MainSeasonPgCtrl
      constructor: ->
        # Get activities for the current season
        seasons.activities().then (activities)->
          # Look for the 'INTRODUCTION'
          unless _.find(activities, taxonomy: 'INTRODUCTION')
            # Redirect to the tutorial for this season
            $state.transitionTo 'main.season.pg.intro'
