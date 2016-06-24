angular.module 'jquest'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.season.pg.level.round',
        controller: 'MainSeasonPgLevelRoundCtrl'
        controllerAs: 'round'
        templateUrl: 'level/round/round.html'
        params:
          level: null
          round: null
        resolve:
          mandature: (seasons, mandatures)->
            'ngInject'
            angular.copy _.find(mandatures, id: seasons.current().progression.assignment.resource_id)
          person: (people, mandature)->
            'ngInject'
            angular.copy _.find(people, id: mandature.person.id)
