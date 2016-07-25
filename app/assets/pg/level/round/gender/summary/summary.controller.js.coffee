angular.module 'jquest'
  .controller 'MainSeasonPgLevelRoundGenderSummaryCtrl', (summary)->
    'ngInject'
    new class MainSeasonPgLevelRoundGenderSummaryCtrl
      global: summary.global
      assigned: summary.assigned
      genders:
        other:
          name: 'Other'
          color: '#F4CEA5'
        female:
          name: 'Female'
          color: '#4f8258'
        male:
          name: 'Male'
          color: '#824f60'
      genderColor: (gender)=>
        @genders[ gender.toLowerCase() ].color
