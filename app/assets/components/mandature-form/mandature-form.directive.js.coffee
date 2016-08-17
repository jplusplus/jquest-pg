angular.module 'jquest'
  .directive 'mandatureForm', ->
    templateUrl: 'mandature-form/mandature-form.html'
    scope:
      mandature: "="
      allowSkipping: "="
      finally: "&"
    restrict: 'AE'
    controller: 'MandatureFormCtrl'
    controllerAs: 'form'
