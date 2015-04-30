# A generic confirmation for risky actions.
# Usage: Add attributes: ng-really-message="Are you sure"? ng-really-click="takeAction()" function

angular
  .module 'DucksuiteApp' 
  .directive 'ngReallyClick', ->
    restrict: 'A',
    link: (scope, element, attrs) ->
      element.bind 'click', ->
        message = attrs.ngReallyMessage
        if message && confirm(message)
          scope.$apply(attrs.ngReallyClick)