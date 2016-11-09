angular.module 'jquest'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.season.pg.representatives',
        controller: 'MainSeasonPgRepresentativesCtrl'
        controllerAs: 'representatives'
        templateUrl: 'representatives/representatives.html'
        url: 'my-representatives'
        resolve:
          $title: ->
            'My representatives'
          assignments: (assignmentsLoader)->
            'ngInject'
            assignmentsLoader()
