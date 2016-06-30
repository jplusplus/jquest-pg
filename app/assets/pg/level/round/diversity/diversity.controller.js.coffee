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
          do seasons.reload
