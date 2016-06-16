angular.module 'jquest'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.season.pg.level',
        controller: 'MainSeasonPgLevelCtrl'
        controllerAs: 'level'
        templateUrl: 'level/level.html'
        url: "level/:level"
