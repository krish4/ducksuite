angular
  .module 'DucksuiteApp' 
  .directive 'ngEnter', ->
    (scope, element, attrs) ->
      element.bind "keydown keypress", (event) ->
        if event.which is 13 
          scope.$apply ->
            scope.$eval(attrs.ngEnter)
          event.preventDefault()