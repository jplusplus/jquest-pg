module.exports = (seasons, mandature, mandatures, SETTINGS, $state)->
  'ngInject'
  new class MainSeasonPgLevelRoundCtrl
    title: SETTINGS.ROUNDS[seasons.current().progression.round - 1].title
    description: SETTINGS.ROUNDS[seasons.current().progression.round - 1].description
    mandature: mandature
    # Find the currency assignment according to the user activity
    isCurrentMandature: (mandature)->
      @mandature.id is mandature.id
    indexOfCurrentMandature: =>
      _.indexOf _.map(mandatures, 'id'), mandature.id
    getAssignmentWrapperStyle: (index)->
      # Get index of the current assignement to deduce the offset
      index = do @indexOfCurrentMandature
      # 175 is the width (in percentage of the wrapper)
      width = 165
      # Calculate the ratio of one entity according to the width of the wrapper
      ratio = 1/(6*100/width)*100
      # Return a relative left position
      left: (-index * ratio) + '%'
      marginLeft: 50 - (1/6*width)/2 + '%'
    # Redirect to a child state according to the current round
    constructor: ->
      if seasons.current().progression.remaining >= 6
        $state.go 'main.season.pg.level.round.intro'
      else
        switch seasons.current().progression.round
          when 1 then $state.go 'main.season.pg.level.round.gender'
          when 2 then $state.go 'main.season.pg.level.round.details'
          when 3 then $state.go 'main.season.pg.level.round.diversity'
