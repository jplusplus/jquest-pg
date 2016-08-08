angular.module 'jquest'
  .controller 'MandatureFormCtrl', ($uibModal, $scope, $state, $q, SETTINGS, Seasons, Restangular)->
    'ngInject'
    new class MandatureFormCtrl
      # Common attributes
      mandature: $scope.mandature
      # A hash of object clones
      clones: {}
      # Available values for select
      professionCategories: SETTINGS.PROFESSION_CATEGORIES
      politicalLeanings: SETTINGS.POLITICAL_LEANINGS
      # Creates clones to track changes on the main resources
      constructor: ->
        @createClone @mandature
        @createClone @mandature.person
      submit: (resources)=>
        $q.all([ @mandature.person.put(), @mandature.put() ]).finally $scope.finally
      editSource: (field, resource)=>
        # Create a modal
        @editSourceModal = $uibModal.open
          templateUrl: 'mandature-form/source/source.html'
          # Inherit froom the current scope
          scope: $scope.$new()
          controller: ($scope, $uibModalInstance)=>
            'ngInject'
            # The scope's source is the one find with this field for this resource
            $scope.source = @getSource(field, resource) or { value: '', field: field }
            # Avoid modifing original value directly
            $scope.source = angular.copy $scope.source
            # Send the value as modal's result
            $scope.submit = -> $uibModalInstance.close($scope.source.value)
        # Closure function to save the source
        @editSourceModal.result.then @saveSourceFn(field, resource)
      # Get changes count
      changes: (sourced=no)=>
        # Get changes count for the two resources
        @getChanges(@mandature.person, sourced).length + @getChanges(@mandature, sourced).length
      saveSourceFn: (field, resource)=>
        (value)=>
          @setSource field, resource, value
      getSource: (field, resource, fallback=null)=>
        # Use a fallback from legislature source
        fallback = { value: @mandature.legislature.source } if fallback
        # Find the source for this field
        _.find(resource.sources or [], field: field) or fallback
      requiresSource: (field)=>
        # Some field don't require source
        -1 is ['image'].indexOf field
      hasSource: (field, resource)=>
        source = @getSource(field, resource)
        (!!source) and source.value isnt ''
      setSource: (field, resource, value)=>
        # Find the source
        source = @getSource field, resource
        # The source already exists
        if source?
          # We simply edit it
          source.value = value
        # We create the source
        else
          # Source are save as an object
          resource.sources.push value: value, field: field
      createClone: (resource)=>
        # Create unique id if needed
        resource.$$uid = resource.$$uid or do _.uniqueId
        # Save the clone using this id
        # WARNING: the $$uid is not duplicated during cloning
        @clones[resource.$$uid] = resource.clone()
      hasClone: (resource)=>
        resource.$$uid? and @clones[resource.$$uid]?
      getClone: (resource)=>
        # Should we create the clone
        @createClone(resource) unless @hasClone resource
        # Simply get the clone
        @clones[resource.$$uid]
      # Get changes for the given resource
      getChanges: (resource, sourced=no)=>
        # Find the clone of this resource
        clone = @getClone resource
        # An array of field that changed
        changed = []
        # Look into every literal field one by one
        for own key, value of clone.plain() when not (value instanceof Object)
          # Did the value value changed
          unless clone[key] is resource[key] or resource[key] is ''
            # Do the value must be sourced? If yes, has it got a source?
            if not sourced or not @requiresSource(key) or @hasSource key, resource
              # Add it to the list!
              changed.push key
        # Returns the array of changed field
        changed
