module.exports = (seasons, seasonRestangular, $state, $stateParams)->
  'ngInject'
  new class MainSeasonPgLevelRoundGenderCtrl
    isSubmitted: => @promise?
    isLoading: => @isSubmitted() and @promise.$$state.status is 0
    isLocked: => @isSubmitted() and @promise.$$state.status < 2
    male: (person)=> @genderize person, 'male'
    other: (person)=> @genderize person, 'other'
    female: (person)=> @genderize person, 'female'
    genderize: (person, value)=>
      # Avoid genderize twice
      return if @isLocked()
      # Save choice for displaying purpose
      person.choice = value
      # Wait for the season to be ready before getting assigments
      @promise = seasonRestangular
        .one('people', person.id)
        .all('genderize')
        .post gender: value
        .finally (r)=>
          # Reload progression
          seasons.reload().then =>
            # Still on this round
            if seasons.current().progression.round is 1
              # Once the season is reloaded, we might refresh the current round
              $state.go 'main.season.pg.level.round', $stateParams, reload: 'main.season.pg.level.round'
            # A new level started!
            else
              # Go back to the summary screen
              $state.go 'main.season.pg.level.round.gender.summary'
