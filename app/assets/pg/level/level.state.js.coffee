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
          assignements: (seasons, SeasonRestangular)->
            'ngInject'
            # Wait for the season to be ready before getting assigments
            SeasonRestangular().one('mandatures').one('assigned').getList()
