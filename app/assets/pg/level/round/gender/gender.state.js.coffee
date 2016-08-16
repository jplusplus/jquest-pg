angular.module 'jquest'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.season.pg.level.round.gender',
        controller: 'MainSeasonPgLevelRoundGenderCtrl'
        controllerAs: 'gender'
        templateUrl: 'level/round/gender/gender.html'
        resolve:
          $title: (mandature)->
            'ngInject'
            mandature.person.fullname
