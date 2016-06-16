angular.module 'jquest'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.season.pg',
        controller: 'MainSeasonPgCtrl'
        controllerAs: 'pg'
        templateUrl: 'pg.html'
        resolve:
          assignements: (seasons, SeasonRestangular)->
            'ngInject'
            # Wait for the season to be ready before getting assigments
            seasons.ready ->
              SeasonRestangular().one('persons').one('assigned').getList()
          progression: (seasons)->
            'ngInject'
            seasons.current().one('progression').get()
