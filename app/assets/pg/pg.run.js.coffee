#= require_tree .
angular.module 'jquest'
  .run (Menu, $rootScope, $state)->
      'ngInject'
      # Redirect to the right state
      $rootScope.$on '$stateChangeSuccess', (ev, state)->
        if -1 isnt ['main', 'main.season'].indexOf state.name
          $state.transitionTo 'main.season.pg'
      # Menus items
      Menu.addItem name: "Watch intro again", state: 'main.pg.intro', category: 'Tutorials'
      Menu.addItem name: "How-to", state: 'main.pg.tutorials', category: 'Tutorials'
      Menu.addItem name: "Cheatsheet", state: 'main.pg.cheatsheet', category: 'Tutorials'
      Menu.addItem name: "My tasks", state: 'main.pg.tasks', category: 'Your mission', priority: 100
      Menu.addItem name: "Leaderboard", state: 'main.pg.leaderboard', category: 'Your mission'
      Menu.addItem name: "Collected data", state: 'main.pg.data', category: 'Your mission'
      Menu.addItem name: "About", state: 'main.pg.about'
