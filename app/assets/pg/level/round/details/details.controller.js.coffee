angular.module 'jquest'
  .controller 'MainSeasonPgLevelRoundDetailsCtrl', ($uibModal, $scope, SeasonRestangular, PROFESSION_CATEGORIES, POLITICAL_LEANINGS)->
    'ngInject'
    new class MainSeasonPgLevelRoundDetailsCtrl
      professionCategories: PROFESSION_CATEGORIES
      politicalLeanings: POLITICAL_LEANINGS
      editSource: (field, resource)=>
        $uibModal.open
          templateUrl: 'level/round/details/source/source.html'
          scope: $scope.$new()
          controller: ($scope)=>
            'ngInject'
            $scope.source = @getSource(field, resource) or { value: '', field: field }
      getSource: (field, resource)=>
        _.find(resource.sources or [], field: field)
      hasSource: (field, resource)=>
        !! @getSource(field, resource)
