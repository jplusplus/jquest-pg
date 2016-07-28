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
          assignment: null
        resolve:
          $title: (seasons)->
            'ngInject'
            'Round ' + seasons.current().progression.round
          mandature: (seasons, mandatures, Restangular)->
            'ngInject'
            # Get the resource id
            mid = seasons.current().progression.assignment.resource_id
            # Find the mandature that match with this id
            mandature = _.find(mandatures, id: mid)
            # Copy it
            mandature = Restangular.copy mandature
            # Restangularize nested elements
            Restangular.restangularizeElement mandature, mandature.person
            Restangular.restangularizeElement mandature, mandature.legislature
            # Returns the mandature
            mandature
