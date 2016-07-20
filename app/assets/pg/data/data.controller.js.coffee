angular.module 'jquest'
  .controller 'MainSeasonPgDataCtrl', (mandatures, Paginator)->
    'ngInject'
    new class MainSeasonPgDataCtrl
      all: new Paginator mandatures
