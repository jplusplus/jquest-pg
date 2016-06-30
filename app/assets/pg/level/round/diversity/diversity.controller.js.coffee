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
            # Once the season is reloaded, we might refresh the current round
            $state.go 'main.season.pg.level.round', seasons.current().progression
