angular.module 'jquest'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.season.pg.representatives.edit',
        url: '/:id'
        templateUrl: 'representatives/edit/edit.html'
        controller: 'MainSeasonPgRepresentativesEditCtrl'
        controllerAs: 'edit'
        resolve:
          $title: ->
            'Edit'
          done: (seasonRestangular)->
            seasonRestangular.all('mandatures').one('assigned').getList('done', limit: 100)
          mandature: (seasonRestangular, $stateParams, $state, done, growl)->
            'ngInject'
            # Are we allowed to edit this?
            unless _.some(done, (m)-> m.id is (1 * $stateParams.id) )
              # Redirect to the parent state
              $state.go 'main.season.pg.representatives'
              # And notify the user
              growl.error 'You are not allowed to do this'
            else
              seasonRestangular.all('mandatures').one($stateParams.id).get().then (mandature)->
                # Restangularize nested elements
                seasonRestangular.restangularizeElement mandature, mandature.person
                seasonRestangular.restangularizeElement mandature, mandature.legislature
                # Return the mandature
                mandature
