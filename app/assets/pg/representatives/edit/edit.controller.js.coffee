angular.module 'jquest'
  .controller 'MainSeasonPgRepresentativesEditCtrl', (mandature, $state, growl)->
    'ngInject'
    new class MainSeasonPgRepresentativesEditCtrl
      mandature: mandature
      finally: ->
        growl.success 'Modification saved'
        $state.go '^'
