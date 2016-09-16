angular.module 'jquest'
  .controller 'MainSeasonPgRepresentativesEditCtrl', (mandature, $state, growl, seasons)->
    'ngInject'
    new class MainSeasonPgRepresentativesEditCtrl
      mandature: mandature
      finally: ->
        # Informs the user
        growl.success 'Modification saved'
        # Reload season progression (for updated points)
        do seasons.reload
        # Go to the parent state
        $state.go '^', null, reload: 'main.season.pg'
