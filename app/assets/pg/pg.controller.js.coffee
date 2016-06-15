angular.module 'jquest'
  .controller 'MainSeasonPgCtrl', (seasons, progression, $state, LEVELS, CATEGORIES)->
    'ngInject'
    new class MainSeasonPgCtrl
      buildLevel: (level, index)->
        angular.extend {
          locked: (index + 1) > progression.level
        }, level
      category:  CATEGORIES
      constructor: ->
        # Group levels by categories
        @categories = _.chain(LEVELS).map(@buildLevel).groupBy('category').value()
        # Get activities for the current season
        seasons.activities().then (activities)->
          # Look for the 'INTRO'
          unless _.find(activities, taxonomy: 'INTRO')
            # Redirect to the tutorial for this season
            $state.go 'main.season.pg.intro'
