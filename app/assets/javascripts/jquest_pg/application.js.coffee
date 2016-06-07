#= require_tree .
angular.module 'jquest'
  .run (Menu)->
      'ngInject'
      # Menus items
      Menu.addItem name: "Watch intro again", state: 'main.pg.intro', category: 'Tutorials'
      Menu.addItem name: "How-to", state: 'main.pg.tutorials', category: 'Tutorials'
      Menu.addItem name: "My tasks", state: 'main.pg.tasks', category: 'Your mission', priority: 100
      Menu.addItem name: "Leaderboard", state: 'main.pg.leaderboard', category: 'Your mission'
      Menu.addItem name: "Collected data", state: 'main.pg.data', category: 'Your mission'
      Menu.addItem name: "About", state: 'main.pg.about'
  .run ($rootScope, $state)->
    'ngInject'
    $rootScope.$on '$stateChangeSuccess', (ev, state)->
      $state.go 'main.pg' if state.name is 'main'
  .config ($stateProvider)->
    'ngInject'
    $stateProvider
      .state 'main.pg',
        template: '<div class="container" ui-view>ok</div>'
      .state 'main.pg.intro',
        template: '<div class="container">intro</div>'
        url: 'intro'
