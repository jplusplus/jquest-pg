angular.module 'jquest'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.season.pg',
        controller: 'MainSeasonPgCtrl'
        controllerAs: 'pg'
        templateUrl: 'pg.html'
        resolve:
          $title: -> 'Your missions'
          nocontent: ($state)->
            'ngInject'
            # Closure function that redirect to the 403 state
            ->
              # Redirect to error 204 page
              $state.go 'main.season.pg.204'
