angular.module 'jquest'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.season.pg.level',
        controller: 'MainSeasonPgLevelCtrl'
        controllerAs: 'level'
        templateUrl: 'level/level.html'
        url: "play"
        resolve:
          mandatures: (seasonRestangular)->
            'ngInject'
            seasonRestangular.one('mandatures').one('assigned').one('pending').getList()
          people: (seasonRestangular)->
            'ngInject'
            seasonRestangular.one('people').one('assigned').one('pending').getList()
