module.exports = ($stateProvider)->
  'ngInject'
  $stateProvider
    .state 'main.season.pg.intro',
      controller: 'MainSeasonPgIntroCtrl'
      controllerAs: 'intro'
      template: require './intro.html'
      url: 'intro'
      resolve:
        $title: -> 'Introduction'
