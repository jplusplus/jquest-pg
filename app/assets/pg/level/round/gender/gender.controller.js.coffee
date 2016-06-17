angular.module 'jquest'
  .controller 'MainSeasonPgLevelRoundGenderCtrl', (assignements, seasons, SeasonRestangular)->
    'ngInject'
    new class MainSeasonPgLevelRoundGenderCtrl
      constructor: ->
      male: (person)=> @genderize person, 'male'
      other: (person)=> @genderize person, 'other'
      female: (person)=> @genderize person, 'female'
      genderize: (person, value)->
        # Wait for the season to be ready before getting assigments
        SeasonRestangular()
          .one('persons', person.id)
          .all('genderize')
          .post gender: value
          .finally (r)->
            # Reload progression
            do seasons.reload
