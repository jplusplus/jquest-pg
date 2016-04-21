# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require_tree .
angular.module 'jquest'
  .run (Menu)->
      # Global menu option
      Menu.setTitle 'Political Gaps'
      Menu.setPrimaryColor '#81A9CC'
      # Menus items
      Menu.addItem name: "Watch intro again", state: 'main.pg.intro', category: 'Tutorials'
      Menu.addItem name: "How-to", state: 'main.pg.tutorials', category: 'Tutorials'
      Menu.addItem name: "My tasks", state: 'main.pg.tasks', category: 'Your mission', priority: 100
      Menu.addItem name: "Leaderboard", state: 'main.pg.leaderboard', category: 'Your mission'
      Menu.addItem name: "Collected data", state: 'main.pg.data', category: 'Your mission'
      Menu.addItem name: "About", state: 'main.pg.about'
  .run ($rootScope, $state)->
    $rootScope.$on '$stateChangeSuccess', (ev, state)->
      $state.go 'main.pg' if state.name is 'main'
  .config ($stateProvider)->
    $stateProvider
      .state 'main.pg',
        template: '<div class="container" ui-view>ok</div>'
      .state 'main.pg.intro',
        template: '<div class="container">intro</div>'
        url: 'intro'
