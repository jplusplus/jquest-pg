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
          mandatures: (seasons, SeasonRestangular)->
            'ngInject'
            SeasonRestangular().one('mandatures').one('assigned').getList()
          people: (seasons, SeasonRestangular)->
            'ngInject'
            SeasonRestangular().one('people').one('assigned').getList()
