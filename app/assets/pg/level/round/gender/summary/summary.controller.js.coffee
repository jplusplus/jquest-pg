angular.module 'jquest'
  .controller 'MainSeasonPgLevelRoundGenderSummaryCtrl', (summary)->
    'ngInject'
    new class MainSeasonPgLevelRoundGenderSummaryCtrl
      global: _.chain(summary.global.gender).toPairs().orderBy( (a)-> a[0] ).value()
      assigned: _.chain(summary.assigned.gender).toPairs().orderBy( (a)-> a[0] ).value()
      genders:
        other:
          name: 'Other'
          color: '#F4CEA5'
        male:
          name: 'Male'
          color: '#4f8258'
        female:
          name: 'Female'
          color: '#824f60'
      genderColor: (gender)=>
        @genders[ gender.toLowerCase() ]?.color
