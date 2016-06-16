angular.module 'jquest'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.season.pg',
        controller: 'MainSeasonPgCtrl'
        controllerAs: 'pg'
        templateUrl: 'pg.html'
        resolve:
          assignements: (SeasonRestangular)->
            'ngInject'
            SeasonRestangular().one('persons').one('assigned').getList()
          progression: (seasons)->
            'ngInject'
            seasons.current().one('progression').get()
