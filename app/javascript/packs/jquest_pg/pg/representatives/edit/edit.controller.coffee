module.exports = (mandature, $state, growl, seasons)->
  'ngInject'
  new class MainSeasonPgRepresentativesEditCtrl
    mandature: mandature
    then: ->
      # Informs the user
      growl.success 'Modification saved'
      # Reload season progression (for updated points)
      do seasons.reload
      # Go to the parent state
      $state.go '^', null, reload: 'main.season.pg.representatives'
