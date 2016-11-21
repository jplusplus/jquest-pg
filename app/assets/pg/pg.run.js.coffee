#= require_tree .
angular.module 'jquest'
  .run (Menu, $rootScope, $state, Seasons)->
      'ngInject'
      # Redirect to the right state
      $rootScope.$on '$stateChangeSuccess', (ev, state)->
        if -1 isnt ['main', 'main.season'].indexOf state.name
          $state.go 'main.season.pg'
      # Add taxonomy human translation
      Seasons.addHumanTaxonomy 'seen', 'You consulted the course material <strong>{{ resource.title }}</strong>.'
      Seasons.addHumanTaxonomy 'intro', 'You watched the introduction.'
      Seasons.addHumanTaxonomy 'genderize', 'You assigned a gender to <strong>{{ resource.fullname }}</strong>.'
      Seasons.addHumanTaxonomy 'details', 'You updated information about <strong>{{ resource.fullname || resource.name }}</strong>.'
      Seasons.addHumanTaxonomy 'diversity', 'You compared <strong>{{ resource.resource_b.fullname }}</strong> with someone else.'
      Seasons.addHumanTaxonomy 'extra', 'You earned extra points for helping the community.'
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
