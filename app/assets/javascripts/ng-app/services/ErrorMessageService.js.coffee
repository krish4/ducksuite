ErrorMessageService = ->

  display: ->
    $.fancybox.open
      openSpeed: 500
      closeSpeed: 500
      autoSize: false
      width: 500
      height: 100
      wrapCSS: 'error-notification'
      content: '<p>We are sorry, but something went wrong.</p><p>Please, try again later or contact the administrator.</p>'

angular
  .module 'DucksuiteApp'
  .factory 'ErrorMessageService', [ErrorMessageService]