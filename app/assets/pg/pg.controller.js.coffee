angular.module 'jquest'
  .controller 'MainSeasonPgCtrl', (seasons, $state, LEVELS, CATEGORIES)->
    'ngInject'
    new class MainSeasonPgCtrl
      progression: seasons.current().progression
      buildLevel: (level, index)->
        angular.extend {
          # Level is not unlocked yet
          locked: (index + 1) > seasons.current().progression.level
          # Level is done, congrats!
          done: (index + 1) < seasons.current().progression.level
        }, level
      category:  CATEGORIES
      constructor: ->
        # Group levels by categories
        @categories = _.chain(LEVELS).map(@buildLevel).groupBy('category').value()
        # Get activities for the current season
        seasons.activities().then (activities)->
          # Look for the 'intro'
          unless _.find(activities, taxonomy: 'intro')
            # Redirect to the tutorial for this season
            $state.go 'main.season.pg.intro'
