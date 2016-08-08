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
            console.log seasons.current().progression
            midx = mandatures.length - seasons.current().progression.remaining
            # Find the mandature that match with this idx
            mandature = Restangular.copy mandatures[midx]
            # Restangularize nested elements
            Restangular.restangularizeElement mandature, mandature.person
            Restangular.restangularizeElement mandature, mandature.legislature
            # Returns the mandature
            mandature
