module.exports = ($stateProvider)->
  'ngInject'
  $stateProvider
    .state 'main.season.pg.level.round.intro',
      controller: 'MainSeasonPgLevelRoundIntroCtrl'
      controllerAs: 'intro'
      template: require './intro.html'
