angular.module 'jquest'
  .controller 'MainSeasonPgLevelRoundDetailsCtrl', ($uibModal, $scope, seasons, mandatures, people, SeasonRestangular, PROFESSION_CATEGORIES, POLITICAL_LEANINGS)->
    'ngInject'
    new class MainSeasonPgLevelRoundDetailsCtrl
      professionCategories: PROFESSION_CATEGORIES
      politicalLeanings: POLITICAL_LEANINGS
      editSource: (field, resource)=>
        $uibModal.open
          templateUrl: 'level/round/details/source/source.html'
          scope: $scope
      constructor: ->
        @assignementResourceId = seasons.current().progression.assignment.resource_id
        @mandature = angular.copy _.find(mandatures, id: @assignementResourceId)
        @person = angular.copy _.find(people, id: @mandature.person.id)
