module.exports = ($stateProvider)->
  'ngInject'
  $stateProvider
    .state 'main.season.pg.level.round.details.summary',
      controller: 'MainSeasonPgLevelRoundDetailsSummaryCtrl'
      controllerAs: 'summary'
      template: require './summary.html'
      resolve:
        $title: -> 'Summary'
        summary: (seasonRestangular)->
          'ngInject'
          seasonRestangular.one('mandatures').one('summary').get()
