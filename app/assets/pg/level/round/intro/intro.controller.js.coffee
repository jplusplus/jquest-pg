angular.module 'jquest'
  .controller 'MainSeasonPgLevelRoundIntroCtrl', (hotkeys, $state, $stateParams)->
    'ngInject'
    new class MainSeasonPgLevelRoundIntroCtrl
      _indexSlide: if $stateParams.round is 1 then 0 else 2
      _slides: ['level', 'representatives', 'round']
      _states: [
        'main.season.pg.level.round.gender'
        'main.season.pg.level.round.details'
        'main.season.pg.level.round.diversity'
      ]
      constructor: ->
        # Bind keyboard shortcuts
        hotkeys.add
          combo: ['right', 'space', 'enter']
          description: "Go to the next slide."
          callback: =>
            # Can go to the next slide durring
            do @next unless @current().type is 'question'
        hotkeys.add
          combo: ['left']
          description: "Go to the previous slide."
          callback: => do @prev
        hotkeys.add
          combo: ['esc']
          description: "End the introduction."
          callback: => do @end
      # Ends intro
      end: =>
        # Redirect to right round
        $state.go @getNextState()
      # Next slide!
      next: =>
        if @_indexSlide + 1 >= @_slides.length
          # End the introduction!
          do @end
        # Not finished yet
        else
          @_indexSlide = Math.min @_indexSlide + 1, @_slides.length - 1
      # Previous slide!
      prev: =>
        @_indexSlide = Math.max @_indexSlide - 1, 0
        # Reset choice
        @_slides[@_indexSlide].choice = null
      # True when we reach the last slide
      last: =>
        @_indexSlide is @_slides.length - 1
      # Current slide
      current: => @_slides[@_indexSlide]
      # Get next state according to the progression
      getNextState: => @_states[$stateParams.round - 1]
