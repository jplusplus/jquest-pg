angular.module 'jquest'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.season.pg.level',
        controller: 'MainSeasonPgLevelCtrl'
        controllerAs: 'level'
        templateUrl: 'level/level.html'
        url: "play"
        params:
          level:     null
          round:     null
          remaining: null
        resolve:
          $title: (seasons)->
            'ngInject'
            'Level ' + seasons.current().progression.level
          mandatures: (seasonRestangular)->
            'ngInject'
            seasonRestangular.one('mandatures').one('assigned').one('pending').getList()
          people: (mandatures, Restangular)->
            'ngInject'
            _.chain(mandatures).clone().map('person').map(Restangular.restangularizeElement).value()
