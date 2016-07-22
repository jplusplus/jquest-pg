angular.module 'jquest'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.season.pg.level.round.gender.summary',
        url: '/summary'
        controller: 'MainSeasonPgLevelRoundSummaryCtrl'
        controllerAs: 'summary'
        templateUrl: 'level/round/gender/summary/summary.html'
        resolve:
          summary: (seasons, SeasonRestangular)->
            'ngInject'
            SeasonRestangular().one('mandatures').one('summary').get()
