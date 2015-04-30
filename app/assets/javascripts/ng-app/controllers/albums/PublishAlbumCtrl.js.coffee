angular
  .module 'DucksuiteApp'
  .controller 'PublishAlbumCtrl', ['$scope', '$location', ($scope, $location) ->

    # Select default album type
    $scope.currentAlbumType = 'photowall'

    $scope.setCurrentAlbumType = (albumType) ->
      $scope.currentAlbumType = albumType

    # Nice way to extract information from the url
    getLocation = (href) ->
      l = document.createElement("a")
      l.href = href
      return l

    # Pass result to the template
    href = getLocation($location.absUrl())

    # Do not copy script by default
    $scope.isScriptCopied = false

    $scope.scriptToCopy = ->
      "<script src=\"http://#{href.host}/widget/#{$scope.currentAlbumType}/#{$scope.$parent.album.id}\"></script>"

    $scope.setScriptAsCopied = (isCopied) ->
      $scope.isScriptCopied = !!isCopied

  ]
