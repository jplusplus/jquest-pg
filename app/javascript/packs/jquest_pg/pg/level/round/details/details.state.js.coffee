angular.module 'jquest'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.season.pg.level.round.details',
        controller: 'MainSeasonPgLevelRoundDetailsCtrl'
        controllerAs: 'details'
        templateUrl: 'level/round/details/details.html'
        resolve:
          $title: (mandature)->
            'ngInject'
            mandature.person.fullname
