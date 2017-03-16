module.exports = ($stateProvider)->
  'ngInject'
  $stateProvider
    .state 'main.season.pg.level.round.gender',
      controller: 'MainSeasonPgLevelRoundGenderCtrl'
      controllerAs: 'gender'
      template: require './gender.html'
      resolve:
        $title: (mandature)->
          'ngInject'
          mandature.person.fullname
