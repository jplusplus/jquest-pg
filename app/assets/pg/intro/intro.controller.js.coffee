angular.module 'jquest'
  .controller 'MainSeasonPgIntroCtrl', (INTRO, hotkeys, $timeout)->
    'ngInject'
    new class MainSeasonPgIntroCtrl
      _indexSlide: 0
      constructor: ->
        angular.extend @, angular.copy(INTRO)
        # Bind keyboard shortcuts
        hotkeys.add
          combo: ['right', 'space']
          description: "Go to the next slide."
          callback: =>
            # Can go to the next slide durring
            do @next unless @current().type is 'question'
        hotkeys.add
          combo: ['left']
          description: "Go to the previous slide."
          callback: => do @prev
      # Next slide!
      next: =>
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
