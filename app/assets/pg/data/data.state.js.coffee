angular.module 'jquest'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.season.pg.data',
        controller: 'MainSeasonPgDataCtrl'
        controllerAs: 'data'
        templateUrl: 'data/data.html'
        url: 'data'
        resolve:
          mandatures: (seasons, SeasonRestangular)->
            'ngInject'
            SeasonRestangular().all('mandatures').getList()
