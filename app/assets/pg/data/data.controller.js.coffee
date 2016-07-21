angular.module 'jquest'
  .controller 'MainSeasonPgDataCtrl', (mandatures, Paginator, Restangular, SeasonRestangular, $state, $stateParams)->
    'ngInject'
    new class MainSeasonPgDataCtrl
      filter: =>
        # Apply the filter by passing the object as state params
        $state.go 'main.season.pg.data', @filters
      # Get initials filter from the state params
      filters: angular.copy($stateParams)
      # All mandatures resolved by this state
      all: new Paginator mandatures
      # True is there is any result
      hasMandatures: mandatures.length
      # True if there is any filter
      isFiltered: !!_.chain($stateParams).values().compact().value().length
      # Build CSV Download URL
      csv: mandatures.getRequestedUrl().replace(/mandatures/, 'mandatures.csv') + '&limit=' + 1e4
      # List of all countries
      countries: Restangular.all('countries').withHttpConfig(cache: yes).getList(limit: 300).$object
      # List of all legislatures
      legislatures: SeasonRestangular().all('legislatures').withHttpConfig(cache: yes).getList(limit: 300).$object
