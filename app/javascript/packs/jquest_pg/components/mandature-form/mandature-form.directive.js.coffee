module.exports = ->
    template: require './mandature-form.html'
    scope:
      mandature: "="
      allowSkipping: "="
      then: "&"
    restrict: 'AE'
    controller: 'MandatureFormCtrl'
    controllerAs: 'form'
