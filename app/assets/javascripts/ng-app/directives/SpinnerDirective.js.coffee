Spinner = ->
  restrict: 'E'
  template: [
    '<div class="spinner">',
      '<div class="spinner-container">',
        '<div class="circle1"></div>',
        '<div class="circle2"></div>',
        '<div class="circle3"></div>',
        '<div class="circle4"></div>',
      '</div>',
    '</div>'
  ].join('')

angular
  .module('DucksuiteApp')
  .directive('spinner', Spinner)