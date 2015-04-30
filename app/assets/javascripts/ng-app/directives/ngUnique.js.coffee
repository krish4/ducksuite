angular
  .module 'DucksuiteApp' 
  .directive 'unique', ->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, element, attrs, ctrl) ->
      ctrl.$parsers.unshift (value) ->
        names = _.map(scope.data.user.domains, (d)-> d.name )
        valid = !_.contains(names, value)
        ctrl.$setValidity('unique', valid)

        return (if valid then value else `undefined`)
