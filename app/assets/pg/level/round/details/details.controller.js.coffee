angular.module 'jquest'
  .controller 'MainSeasonPgLevelRoundDetailsCtrl', ($uibModal, $scope, seasons, SeasonRestangular, PROFESSION_CATEGORIES, POLITICAL_LEANINGS)->
    'ngInject'
    new class MainSeasonPgLevelRoundDetailsCtrl
      professionCategories: PROFESSION_CATEGORIES
      politicalLeanings: POLITICAL_LEANINGS
      editSource: (field, resource)=>
        $uibModal.open
          templateUrl: 'level/round/details/source/source.html'
          scope: $scope
      constructor: ->
        @mandature = angular.copy seasons.current().progression.assignment?.resource
        @person = angular.copy @mandature.person
