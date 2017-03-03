module.exports = ($stateProvider)->
  'ngInject'
  $stateProvider
    .state 'main.season.pg.level.round.diversity',
      controller: 'MainSeasonPgLevelRoundDiversityCtrl'
      controllerAs: 'diversity'
      template: require './diversity.html'
      resolve:
        $title: (mandature)->
          'ngInject'
          mandature.person.fullname
        diversity: (seasonRestangular)->
          'njInject'
          seasonRestangular.all('diversities').one('request').get()
