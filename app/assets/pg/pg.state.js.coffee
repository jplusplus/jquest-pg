angular.module 'jquest'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.season.pg',
        controller: 'MainSeasonPgCtrl'
        controllerAs: 'pg'
        templateUrl: 'pg.html'
