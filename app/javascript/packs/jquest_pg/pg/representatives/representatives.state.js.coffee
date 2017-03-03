module.exports = ($stateProvider)->
  'ngInject'
  $stateProvider
    .state 'main.season.pg.representatives',
      controller: 'MainSeasonPgRepresentativesCtrl'
      controllerAs: 'representatives'
      template: require './representatives.html'
      url: 'my-representatives'
      resolve:
        $title: ->
          'My representatives'
        assignments: (assignmentsLoader)->
          'ngInject'
          assignmentsLoader()
