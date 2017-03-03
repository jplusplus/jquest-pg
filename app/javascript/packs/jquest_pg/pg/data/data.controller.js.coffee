module.exports = (response, user, Paginator, Restangular, seasonRestangular, $state, $stateParams)->
    'ngInject'
    new class MainSeasonPgDataCtrl
      filter: =>
        # Apply the filter by passing the object as state params
        $state.go 'main.season.pg.data', @filters
      constructor: ->
        # Disable download when more than 5000 elements
        @canDownload = @hasMandatures and (@total <= 5000 or user.role is 'admin')
        # Build CSV Download URL
      csv: =>
        response.data.getRequestedUrl().replace(/mandatures/, 'mandatures.csv') + '&limit=' + @total
      # Total number of element for this query
      total: response.headers('Total') || response.headers('X-Total')
      # Get initials filter from the state params
      filters: angular.copy($stateParams)
      # All mandatures resolved by this state
      all: new Paginator response
      # True is there is any result
      hasMandatures: response.data.length
      # True if there is any filter
      isFiltered: !!_.chain($stateParams).values().compact().value().length
      # List of all countries
      countries: Restangular.all('countries').withHttpConfig(cache: yes, ignoreLoadingBar: yes).getList(limit: 300).$object
      # List of all legislatures
      legislatures: seasonRestangular.all('legislatures').withHttpConfig(cache: yes, ignoreLoadingBar: yes).getList(limit: 300).$object
