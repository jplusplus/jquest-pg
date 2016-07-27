angular.module 'jquest'
  .controller 'MainSeasonPgRepresentativesCtrl', (assignments, Paginator)->
    'ngInject'
    new class MainSeasonPgRepresentativesCtrl
      all: new Paginator assignments
