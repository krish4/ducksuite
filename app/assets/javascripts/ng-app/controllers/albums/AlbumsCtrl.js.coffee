angular
  .module 'DucksuiteApp'
  .controller 'AlbumsCtrl', ['$scope', '$location', 'Album', 'LocationMap', 'ErrorMessageService', ($scope, $location, Album, LocationMap, ErrorMessageService) ->
    Album.query {}, (albums) ->
      $scope.albums = albums
    , (error) -> new ErrorMessageService.display

    $scope.showSpinner = -> not $scope.albums
    
    $scope.selectAlbumById = (albumId) ->
      $scope.selectedAlbum = findAlbumById(albumId)

    findAlbumById = (albumId) -> 
      _.findWhere $scope.albums, { id: albumId }

    $scope.loadAlbumByIndex = (albumIndex) -> 
      $scope.areFiltersVisible = false
      $scope.album = $scope.albums[albumIndex]
      $scope.setDefaultValuesForEditingAlbum()

    $scope.setDefaultValuesForNewAlbum = ->
      $scope.areFiltersVisible = false
      $scope.album = {}

    $scope.setDefaultValuesForEditingAlbum = ->
      $scope.areFiltersVisible = false
      $scope.album.location_attributes = $scope.album.location
      $scope.setMapValuesForAlbum()
    
    $scope.setMapValuesForAlbum = ->
      $scope.map = LocationMap.map
      if $scope.album.location?
        LocationMap.setCircleRadius($scope.album.location.radius)
        LocationMap.setCenter($scope.album.location.latitude, $scope.album.location.longitude)

    $scope.changeFiltersVisibility = ->
      $scope.areFiltersVisible = !$scope.areFiltersVisible
      $scope.geocodeAddress() if $scope.areFiltersVisible
      $.fancybox.update()

    $scope.geocodeAddress = -> 
      if $scope.album.location_attributes?
        LocationMap.geocodeAddress($scope.album.location_attributes.name)

    $scope.removeAlbum = (albumIndex) ->
      $scope.flashMessage = {type: 'success', message: 'Album has been removed successfully'}
      album = $scope.albums[albumIndex]
      Album.remove { id: album.id }, (data) ->
        $scope.albums.splice(albumIndex, 1)
      , (error) -> new ErrorMessageService.display

    $scope.redirect = (id) ->
      $location.path("/albums/#{id}/inbox")
  ]