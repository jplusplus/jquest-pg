angular.module 'jquest'
  .controller 'MainSeasonPgLevelRoundGenderCtrl', (assignements, seasons, SeasonRestangular, $timeout)->
    'ngInject'
    new class MainSeasonPgLevelRoundGenderCtrl
      male: (person)=> @genderize person, 'male'
      other: (person)=> @genderize person, 'other'
      female: (person)=> @genderize person, 'female'
      genderize: (person, value)->
        # Save choice for displaying purpose
        person.choice = value
        # Wait for the season to be ready before getting assigments
        SeasonRestangular()
          .one('persons', person.id)
          .all('genderize')
          .post gender: value
          .finally (r)->
            # Reload progression after a short delay
            $timeout seasons.reload, 1000
