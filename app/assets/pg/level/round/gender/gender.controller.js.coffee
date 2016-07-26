angular.module 'jquest'
  .controller 'MainSeasonPgLevelRoundGenderCtrl', (seasons, SeasonRestangular, $timeout, $state)->
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
          .one('people', person.id)
          .all('genderize')
          .post gender: value
          .finally (r)->
            # Reload progression after a short delay
            $timeout(seasons.reload, 600).then ->
              # Still on this round
              if seasons.current().progression.round is 1
                # Once the season is reloaded, we might refresh the current round
                $state.go 'main.season.pg.level.round', seasons.current().progression
              # A new level started!
              else
                # Go back to the summary screen
                $state.go 'main.season.pg.level.round.gender.summary'
