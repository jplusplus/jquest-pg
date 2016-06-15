angular.module 'jquest'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.season.pg',
        controller: 'MainSeasonPgCtrl'
        controllerAs: 'pg'
        templateUrl: 'pg.html'
        resolve:
          progression: (seasons)->
            'ngInject'
            seasons.current().one('progression').get()
