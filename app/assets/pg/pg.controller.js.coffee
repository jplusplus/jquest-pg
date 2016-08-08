angular.module 'jquest'
  .controller 'MainSeasonPgCtrl', (seasons, $state, SETTINGS, Restangular)->
    'ngInject'
    new class MainSeasonPgCtrl
      progression: => seasons.current().progression
      progress: => (6 - @progression().remaining)/6 * 100
      buildLevel: (level, index)=>
        angular.extend {
          pg: @
          # Level is not unlocked yet
          locked: => (index + 1) > @progression().level
          # Level is done, congrats!
          done: => (index + 1) < @progression().level
          # Has the level start?
          started: => @progression().round > 1 or @progression().remaining < 6
          # True if we should display assignements of this level
          displayAssignements: ->
            @pg.assignmentsByLevel?[level.index]? and ( @started() or @done() )
        }, level
      category: SETTINGS.CATEGORIES
      seeksAttentionOnLevel: (level)=>
        @progression().level is level.index and @progression().round is 1
      getAssignments: =>
        Restangular.all('assignments').getList(limit: 100).then (assignments)=>
          # Group all assignments by level
          @assignmentsByLevel = _.groupBy assignments, 'level'
      constructor: ->
        # Get all assignments
        do @getAssignments
        # Group levels by categories
        @categories = _.chain(SETTINGS.LEVELS).map(@buildLevel).groupBy('category').value()
        # Get activities for the current season
        seasons.activities().then (activities)->
          console.log activities
          # Look for the 'intro'
          unless _.find(activities, taxonomy: 'intro')
            # Redirect to the tutorial for this season
            $state.go 'main.season.pg.intro'
