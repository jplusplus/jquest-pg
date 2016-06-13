angular.module 'jquest'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.season.pg.intro',
        controller: 'MainSeasonPgIntroCtrl'
        controllerAs: 'intro'
        templateUrl: 'intro/intro.html'
