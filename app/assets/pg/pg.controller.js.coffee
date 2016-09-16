angular.module 'jquest'
  .controller 'MainSeasonPgCtrl', (seasons, $state, $scope, SETTINGS, assignmentsFn)->
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
        assignmentsFn (assignments)=>
          # Group all assignments by level
          @assignmentsByLevel = _.groupBy assignments, 'level'
      hasExtraLevels: =>
        SETTINGS.LEVELS.length < @progression().level
      getLevels: =>
        # Copy the levels list to be able to duplicate it
        levels = angular.copy SETTINGS.LEVELS
        # Do we have extra levels?
        if @hasExtraLevels()
          # From the level number to the user's level
          for i in [levels.length + 1 .. @progression().level]
            # Create a level with a new title description
            levels.push
              title: "Level #{i}", index: i, description: 'Extra level',
              # The last category contains additional levels
              category: SETTINGS.CATEGORIES.length - 1
        levels
      constructor: ->
        # Get all assignments
        do @getAssignments
        # Group levels by categories
        @categories = _.chain(do @getLevels).map(@buildLevel).groupBy('category').value()
        # Get activities for the current season
        seasons.activities().then (activities)->
          # Look for the 'intro'
          unless _.find(activities, taxonomy: 'intro')
            # Redirect to the tutorial for this season
            $state.go 'main.season.pg.intro'
