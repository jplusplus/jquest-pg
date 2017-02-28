angular.module 'jquest'
  .directive 'mandatureForm', ->
    templateUrl: 'mandature-form/mandature-form.html'
    scope:
      mandature: "="
      allowSkipping: "="
      then: "&"
    restrict: 'AE'
    controller: 'MandatureFormCtrl'
    controllerAs: 'form'
