angular.module 'jquest'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.season.pg.level.round.details.summary',
        controller: 'MainSeasonPgLevelRoundDetailsSummaryCtrl'
        controllerAs: 'summary'
        templateUrl: 'level/round/details/summary/summary.html'
        resolve:
          $title: -> 'Summary'
          summary: (seasonRestangular)->
            'ngInject'
            seasonRestangular.one('mandatures').one('summary').get(topic: 'gender')
