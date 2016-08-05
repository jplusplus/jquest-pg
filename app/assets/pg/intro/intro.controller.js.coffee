angular.module 'jquest'
  .controller 'MainSeasonPgIntroCtrl', (INTRO, hotkeys, $timeout, $state, $scope, seasons)->
    'ngInject'
    new class MainSeasonPgIntroCtrl
      _indexSlide: 0
      constructor: ->
        angular.extend @, angular.copy(INTRO)
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
        seasons.current().one('intro').put().finally ->
          # Reload seasons list (to get new activities)
          seasons.reload().then =>
            # Redirect to homepage of this season
            $state.go 'main.season'
      # Next slide!
      next: =>
        if @_indexSlide + 1 >= @slides.length
          # End the introduction!
          do @end
        # Not finished yet
        else
          @_indexSlide = Math.min @_indexSlide + 1, @slides.length - 1
          # Reset choice
          @slides[@_indexSlide].choice = null
      # Previous slide!
      prev: =>
        @_indexSlide = Math.max @_indexSlide - 1, 0
        # Reset choice
        @slides[@_indexSlide].choice = null
      # Animate next
      yes: (slide)=> @choose slide, 'yes'
      no: (slide)=> @choose slide, 'no'
      # User made a choice
      choose: (slide, choice)=>
        slide.choice = choice
        # Go to the next after a small delay
        $timeout @next, 1000
      # Current slide
      current: => @slides[@_indexSlide]
      # Only one slide visible at once
      filterSlide: (slide, index)=> @_indexSlide is index
