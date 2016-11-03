angular.module 'jquest'
  .controller 'MainSeasonPgLevelRoundDiversityCtrl', (seasons, $state, $stateParams, diversity)->
    'ngInject'
    new class MainSeasonPgLevelRoundDiversityCtrl
      constructor: ->
        @person_a = diversity.resource_a
        @person_b = diversity.resource_b
      # Assertions to avoid submitting several times
      isSubmitted: => @promise?
      isLoading: => @isSubmitted() and @promise.$$state.status is 0
      isLocked: => @isSubmitted() and @promise.$$state.status < 2
      value: (value)=>
        return if @isLocked()
        # Change the diversity value
        diversity.value = value
        # Save it to the database
        @promise = diversity.post().finally ->
          # Reload progression after the promise has been resolved
          seasons.reload().then ->
            # Still on this round
            if seasons.current().progression.round is 3
              # Once the season is reloaded, we might refresh the current round
              $state.go 'main.season.pg.level.round', $stateParams, reload: 'main.season.pg.level.round'
            # A new level started!
            else
              # Go back to the welcome screen
              $state.go 'main.season', {}, reload: yes
