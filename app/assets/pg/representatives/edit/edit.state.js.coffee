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
          mandature: (seasonRestangular, $stateParams)->
            'ngInject'
            seasonRestangular.all('mandatures').one($stateParams.id).get().then (mandature)->
              # Restangularize nested elements
              seasonRestangular.restangularizeElement mandature, mandature.person
              seasonRestangular.restangularizeElement mandature, mandature.legislature
              # Return the mandature
              mandature
