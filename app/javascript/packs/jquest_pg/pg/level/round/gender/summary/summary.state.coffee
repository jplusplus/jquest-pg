module.exports = ($stateProvider)->
  'ngInject'
  $stateProvider
    .state 'main.season.pg.level.round.gender.summary',
      controller: 'MainSeasonPgLevelRoundGenderSummaryCtrl'
      controllerAs: 'summary'
      template: require './summary.html'
      resolve:
        $title: -> 'Summary'
        summary: (seasons, seasonRestangular)->
          'ngInject'
          seasonRestangular.one('mandatures').one('summary').get(topic: 'gender')
