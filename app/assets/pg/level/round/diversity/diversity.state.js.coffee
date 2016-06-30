angular.module 'jquest'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.season.pg.level.round.diversity',
        controller: 'MainSeasonPgLevelRoundDiversityCtrl'
        controllerAs: 'diversity'
        templateUrl: 'level/round/diversity/diversity.html'
        resolve:
          diversity: (SeasonRestangular)->
            'njInject'
            SeasonRestangular().all('diversities').one('request').get()
