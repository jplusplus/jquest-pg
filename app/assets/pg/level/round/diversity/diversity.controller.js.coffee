angular.module 'jquest'
  .controller 'MainSeasonPgLevelRoundDiversityCtrl', (seasons, $state, diversity)->
    'ngInject'
    new class MainSeasonPgLevelRoundDiversityCtrl
      constructor: ->
        @person_a = diversity.resource_a
        @person_b = diversity.resource_b
      value: (value)->
        # Change the diversity value
        diversity.value = value
        # Save it to the database
        diversity.post().finally ->
          # Reload progression after the promise has been resolved
          seasons.reload().then ->
            # Still on this round
            if seasons.current().progression.round is 3
              # Once the season is reloaded, we might refresh the current round
              $state.go 'main.season.pg.level.round', seasons.current().progression
            # A new level started!
            else
              # Go back to the welcome screen
              $state.go 'main.season', {}, reload: yes
