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
          assignmentsFn: ($q, Restangular, seasonRestangular)->
            'ngInject'
            # Two endpoints to combine
            assignments = Restangular.all('assignments').getList(limit: 1000)
            mandatures  = seasonRestangular.all('mandatures').all('assigned').getList(limit: 1000)
            # Resolve the twho endpoint
            promise = $q.all(assignments: assignments, mandatures: mandatures).then (r)->
              # Map assignments to find the corresponding mandature
              _.each r.assignments, (a)->
                # Use the resource field
                a.resource = _.find r.mandatures, id: a.resource_id
            # Return a function to continue before the promise is done
            (fn)-> promise.then(fn)
          nocontent: ($state)->
            'ngInject'
            # Closure function that redirect to the 403 state
            ->
              # Redirect to error 204 page
              $state.go 'main.season.pg.204'
