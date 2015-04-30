angular
.module 'DucksuiteApp'
.directive 'flashMessage', ($compile) ->

  getTemplate = (type, message) ->
    if type is 'success'
      "<div class='notification notification-success'><i class='fa fa-check-circle'></i><p>#{message}</p></div>"
    else if type is 'error'
      "<div class='notification notification-error'><i class='fa fa fa-times-circle'></i><p>#{message}</p></div>"

  update = (scope) ->
    scope.flashMessage = null
    $('.notification').fadeIn(500).delay(3000).fadeOut 500

  linker = (scope, element, attrs) ->
    scope.$watch 'flashMessage', ((value) ->
      if value
        element.html(getTemplate(value.type, value.message)).show()
        update(scope)
    ), true

  restrict: 'A'
  replace: true
  link: linker