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
      Menu.addItem name: "Watch intro again", state: 'main.pg.intro'
      Menu.addItem name: "My tasks", state: 'main.pg.tasks'
      Menu.addItem name: "Tutorials", state: 'main.pg.tutorials'
      Menu.addItem name: "Leaderboard", state: 'main.pg.leaderboard'
      Menu.addItem name: "Collected data", state: 'main.pg.data'
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
