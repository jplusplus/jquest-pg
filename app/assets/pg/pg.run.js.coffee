#= require_tree .
angular.module 'jquest'
  .run (Menu, $rootScope, $state)->
      'ngInject'
      # Redirect to the right state
      $rootScope.$on '$stateChangeSuccess', (ev, state)->
        if -1 isnt ['main', 'main.season'].indexOf state.name
          $state.transitionTo 'main.season.pg'
      # Set search function
      Menu.setSearchFn (q)->
        $state.go 'main.season.pg.data', person_fullname_or_legislature_name_cont: q
      # Menus items
      Menu.addItem
         name: "Watch intro again"
         state: 'main.season.pg.intro'
         category: 'Learn'
         desc: 'Finish each level and collect data on representatives across Europe.'
      Menu.addItem
         name: "Course materials"
         state: 'main.season.course-materials'
         category: 'Learn'
         desc: 'Those materials contain topical information on a specific aspect of datajournalism, they\'ll help you carry out your mission.'
      Menu.addItem
         name: "My representatives"
         state: 'main.season.pg.representatives'
         category: 'Your mission'
         priority: 100
         desc: 'Representatives that you worked on so far. Bring them to 100% to score more points!'
      Menu.addItem
         name: "Leaderboard"
         state: 'main.season.leaderboard'
         category: 'Your mission'
         desc: 'Compare your score to other students and schools.'
      Menu.addItem
         name: "Collected data"
         state: 'main.season.pg.data'
         category: 'Your mission'
         desc: 'Browse the data collected so far. '
