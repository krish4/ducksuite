angular
  .module 'DucksuiteApp' 
  .directive 'domain', ->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, element, attrs, ctrl) ->
      DOMAIN_REGEXP = /^([a-z0-9]+\.)?[a-z0-9][a-z0-9-]*\.[a-z]{2,6}$/i
      ctrl.$parsers.unshift (value) ->
        valid = DOMAIN_REGEXP.test(value)
        ctrl.$setValidity('domain', valid)
        return (if valid then value else `undefined`)
