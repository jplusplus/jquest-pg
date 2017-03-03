module.exports = ($stateProvider)->
  'ngInject'
  $stateProvider
    .state 'main.season.pg.level.round.details',
      controller: 'MainSeasonPgLevelRoundDetailsCtrl'
      controllerAs: 'details'
      template: require './details.html'
      resolve:
        $title: (mandature)->
          'ngInject'
          mandature.person.fullname
