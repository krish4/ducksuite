angular
  .module 'DucksuiteApp'
  .directive 'sampleImages', ($compile) ->

    getTemplate = (images, count) ->
      finalTemplate = ''
      acceptedImages = 0
      for i in [0...images.length]
        if acceptedImages < count
          finalTemplate += "<img src=" + images[i] + ">"
          acceptedImages += 1

      return finalTemplate

    linker = (scope, element, attrs) ->
      element.html(getTemplate(scope.images, attrs.count))

    restrict: 'E'
    scope:
      images: "="
      count: "="
    link: linker


