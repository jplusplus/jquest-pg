angular.module 'jquest'
  .controller 'MainSeasonPgDataCtrl', (mandatures, Paginator, Restangular, SeasonRestangular, $state, $stateParams)->
    'ngInject'
    new class MainSeasonPgDataCtrl
      filter: =>
        $state.go 'main.season.pg.data', @filters
      filters: angular.copy($stateParams)
      all: new Paginator mandatures
      countries: Restangular.all('countries').withHttpConfig(cache: yes).getList(limit: 300).$object
      legislatures: SeasonRestangular().all('legislatures').withHttpConfig(cache: yes).getList(limit: 300).$object
