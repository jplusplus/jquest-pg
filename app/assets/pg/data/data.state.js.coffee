angular.module 'jquest'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.season.pg.data',
        controller: 'MainSeasonPgDataCtrl'
        controllerAs: 'data'
        templateUrl: 'data/data.html'
        url: 'data'
        params:
          legislature__country:
            value:null
          legislature__territory:
            value:null
          legislature:
            value:null
        resolve:
          mandatures: (seasons, SeasonRestangular, $stateParams)->
            'ngInject'
            SeasonRestangular().all('mandatures').getList($stateParams)
