angular.module 'jquest'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.season.pg.level.round.intro',
        controller: 'MainSeasonPgLevelRoundIntroCtrl'
        controllerAs: 'intro'
        templateUrl: 'level/round/intro/intro.html'
