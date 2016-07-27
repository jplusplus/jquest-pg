angular.module 'jquest'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.season.pg.level.round.gender.summary',
        controller: 'MainSeasonPgLevelRoundGenderSummaryCtrl'
        controllerAs: 'summary'
        templateUrl: 'level/round/gender/summary/summary.html'
        resolve:
          summary: (seasons, seasonRestangular)->
            'ngInject'
            seasonRestangular.one('mandatures').one('summary').get()
