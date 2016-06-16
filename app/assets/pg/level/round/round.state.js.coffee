angular.module 'jquest'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.season.pg.level.round',
        # controller: 'MainSeasonPgLevelRoundCtrl'
        # controllerAs: 'round'
        templateUrl: 'level/round/round.html'
        url: "/round/:round"
