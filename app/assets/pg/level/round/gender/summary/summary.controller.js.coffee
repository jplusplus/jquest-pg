angular.module 'jquest'
  .controller 'MainSeasonPgLevelRoundSummaryCtrl', (mandatures, summary)->
    'ngInject'
    new class MainSeasonPgLevelRoundSummaryCtrl
      amongAssignments: _.countBy mandatures, (m)-> m.person.gender
      amongAll: summary.genders
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
