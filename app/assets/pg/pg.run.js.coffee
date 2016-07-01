#= require_tree .
angular.module 'jquest'
  .run (Menu, $rootScope, $state)->
      'ngInject'
      # Redirect to the right state
      $rootScope.$on '$stateChangeSuccess', (ev, state)->
        if -1 isnt ['main', 'main.season'].indexOf state.name
          $state.transitionTo 'main.season.pg'
      # Menus items
      Menu.addItem name: "Watch intro again", state: 'main.season.pg.intro', category: 'Tutorials'
      Menu.addItem name: "How-to", state: 'main.season.pg.tutorials', category: 'Tutorials'
      Menu.addItem name: "Cheatsheet", state: 'main.season.pg.cheatsheet', category: 'Tutorials'
      Menu.addItem name: "My representatives", state: 'main.season.pg.representatives', category: 'Your mission', priority: 100
      Menu.addItem name: "Leaderboard", state: 'main.season.pg.leaderboard', category: 'Your mission'
      Menu.addItem name: "Collected data", state: 'main.season.pg.data', category: 'Your mission'
      Menu.addItem name: "About", state: 'main.season.pg.about'
