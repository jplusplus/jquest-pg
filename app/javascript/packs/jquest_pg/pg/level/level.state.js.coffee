module.exports = ($stateProvider)->
  'ngInject'
  $stateProvider
    .state 'main.season.pg.level',
      controller: 'MainSeasonPgLevelCtrl'
      controllerAs: 'level'
      template: require './level.html'
      url: "play"
      resolve:
        $title: (seasons)->
          'ngInject'
          'Level ' + seasons.current().progression.level
        mandatures: (seasonRestangular)->
          'ngInject'
          seasonRestangular.all('mandatures').all('assigned').all('pending').getList(new: true)
        people: (mandatures, Restangular)->
          'ngInject'
          _.chain(mandatures).clone().map('person').map(Restangular.restangularizeElement).value()
        seasons: (mandatures, seasons)->
          'ngInject'
          seasons.reload().then -> seasons
        hascontent: (mandatures, nocontent)->
          'ngInject'
          do nocontent unless mandatures.length
