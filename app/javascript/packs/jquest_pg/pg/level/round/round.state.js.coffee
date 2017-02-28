angular.module 'jquest'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.season.pg.level.round',
        controller: 'MainSeasonPgLevelRoundCtrl'
        controllerAs: 'round'
        templateUrl: 'level/round/round.html'
        resolve:
          $title: (seasons)->
            'ngInject'
            'Round ' + seasons.current().progression.round
          mandature: (seasons, mandatures, Restangular)->
            'ngInject'
            # Find the mandature that match with this idx
            mandature = Restangular.copy _.find(mandatures, id: seasons.current().progression.next_assignment.resource_id)
            # Restangularize nested elements
            Restangular.restangularizeElement mandature, mandature.person
            Restangular.restangularizeElement mandature, mandature.legislature
            # Returns the mandature
            mandature
