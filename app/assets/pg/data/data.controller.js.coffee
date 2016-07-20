angular.module 'jquest'
  .controller 'MainSeasonPgDataCtrl', (mandatures, Paginator, Restangular, SeasonRestangular)->
    'ngInject'
    new class MainSeasonPgDataCtrl
      filter:
        country: null
        legislature: null
        territory: null
      all: new Paginator mandatures
      countries: Restangular.all('countries').withHttpConfig(cache: yes).getList(limit: 300).$object
      legislatures: SeasonRestangular().all('legislatures').withHttpConfig(cache: yes).getList(limit: 300).$object
