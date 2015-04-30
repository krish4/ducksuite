angular
  .module 'DucksuiteApp'
  .controller 'ShowAlbumCtrl', ['$scope', '$routeParams', 'Album', 'InstagramUser', 'LocationMap', 'WhoLikesPictureText', 'ErrorMessageService', ($scope, $routeParams, Album, InstagramUser, LocationMap, WhoLikesPictureText, ErrorMessageService) ->

    albumId = $routeParams.albumId

    $scope.album =
      location_attributes: {}

    Album.get { id: albumId }, (album) ->
      $scope.album = album
      $scope.album.location_attributes = album.location
      $scope.setDefaultValuesForAlbum()
      getNotificationsInfo()
    , (error) -> new ErrorMessageService.display

    getNotificationsInfo = ->
      $scope.newPicturesNumber = $scope.album.new_pictures_number
      if $scope.newPicturesNumber > 0
        $scope.showNotificationsBox = true
        $scope.recentPictures = $scope.album.recent_pictures.slice(0, 4)

    Album.getPictures { album_id: albumId }, (pictures) ->
      $scope.pictures = pictures
      $scope.addPicturesMarkersOnMap(pictures)
    , (error) -> new ErrorMessageService.display

    $scope.addPicturesMarkersOnMap = (pictures) ->
      $scope.mapMarkers = []
      angular.forEach pictures, (picture) ->
        location = picture.location
        if location?
          $scope.mapMarkers.push
            idKey: picture.id
            coords:
              latitude:  location.latitude
              longitude: location.longitude

    $scope.setDefaultValuesForAlbum = ->
      $scope.areFiltersVisible = false
      $scope.setMapValuesForAlbum()

    $scope.setMapValuesForAlbum = ->
      $scope.map = LocationMap.map
      if $scope.album.location?
        LocationMap.setCircleRadius($scope.album.location.radius)
        LocationMap.setCenter($scope.album.location.latitude, $scope.album.location.longitude)

    $scope.changeFiltersVisibility = ->
      $scope.areFiltersVisible = !$scope.areFiltersVisible
      $scope.setMapValuesForAlbum() if $scope.areFiltersVisible
      $.fancybox.update()

    $scope.geocodeAddress = ->
      if $scope.album.location_attributes?
        LocationMap.geocodeAddress($scope.album.location_attributes.name)

    $scope.locationFilter = (picture) ->
      if $scope.album.location_attributes?
        locationName = $scope.album.location_attributes.name
      return true if not locationName? or locationName.length is 0
      location = picture.location
      if !!location and !!location.latitude and !!location.longitude
        return isInsideCircle($scope.map.circle, location.latitude, location.longitude)
      false

    isInsideCircle = (circle, latitude, longitude) ->
      start = new google.maps.LatLng(circle.center.latitude, circle.center.longitude)
      end   = new google.maps.LatLng(latitude, longitude)
      distance = google.maps.geometry.spherical.computeDistanceBetween(start, end)
      distance <= circle.radius

    $scope.showSpinner = -> not $scope.pictures

    $scope.filterByLikesNumber = (picture) ->
      picture.likes.count >= $scope.album.min_likes_number

    $scope.filterByCommentsNumber = (picture) ->
      picture.comments.count >= $scope.album.min_comments_number

    $scope.filterByFollowersNumber = (picture) ->
      picture.followers_number >= $scope.album.min_followers_number

    $scope.loadPictureById = (pictureId) ->
      $scope.picture = findPictureById(pictureId)
      $scope.likeItText = $scope.createLikeItTextFor($scope.picture)
      InstagramUser.get { id: $scope.picture.user.id }, (user) ->
        $scope.user = user

    findPictureById = (pictureId) ->
      _.findWhere $scope.pictures, { id: pictureId }

    $scope.removePicture = (picture) ->
      pictureIndex = $scope.pictures.indexOf(picture)
      Album.removePicture { album_id: albumId, picture_id: picture.id }, null, (data) ->
        $scope.pictures.splice(pictureIndex, 1)
      , (error) -> new ErrorMessageService.display

    $scope.selectAlbumAsPublished = ->
      if not $scope.album.is_published
        publishAlbumData = { "album": { "is_published": true }}
        Album.update { id: $scope.album.id }, publishAlbumData, (data) ->
          $scope.album.is_published = true
        , (error) -> new ErrorMessageService.display

    $scope.selectAlbumAsPublishedAndClose = ->
      if not $scope.album.is_published
        $scope.selectAlbumAsPublished()
      $.fancybox.close()

    $scope.unpublishAlbum = ->
      if $scope.album.is_published
        unpublishAlbumData = { "album": { "is_published": false }}
        Album.update { id: $scope.album.id }, unpublishAlbumData, (data) ->
          $scope.album.is_published = false
        , (error) -> new ErrorMessageService.display

    $scope.createLikeItTextFor = (picture) -> WhoLikesPictureText.generate(picture)
  ]
