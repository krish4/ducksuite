angular
  .module 'DucksuiteApp'
  .controller 'InboxAlbumCtrl', ['$scope', '$routeParams', 'Album', 'LocationMap', '$route', '$timeout', 'InstagramUser', 'WhoLikesPictureText', 'ErrorMessageService', ($scope, $routeParams, Album, LocationMap, $route, $timeout, InstagramUser, WhoLikesPictureText, ErrorMessageService) ->
    
    albumId = $routeParams.albumId

    $scope.album = 
      location_attributes: {}

    $scope.pictures   = []
    $scope.mapMarkers = []

    Album.get { id: albumId }, (album) ->
      $scope.album = album
      $scope.album.location_attributes = album.location
      $scope.setDefaultValuesForAlbum()
    , (error) -> new ErrorMessageService.display

    $scope.loadingPictures = true
    $scope.requestsLimitReached = false
    $scope.checkingForNewPictures = false
    $scope.showNewPicturesNotification = false
    $scope.showConfirmationLoader = false

    Album.getInboxPictures { album_id: albumId }, (pictures) ->
      $scope.loadingPictures = false
      $scope.olderPicturesExist = true
      if pictures.length
        $scope.pictures = pictures
      else
        $scope.loadMorePictures()
      $scope.addPicturesMarkersOnMap(pictures)
    , (error) -> new ErrorMessageService.display

    $timeout ->
      $scope.notifyAboutNewPictures()
    , 60000

    $scope.notifyAboutNewPictures = ->
      $scope.showNewPicturesNotification = true

    $scope.getPictureCreatedTime = (picture) ->
      new Date(picture.created_time * 1000)

    $scope.showPictureAsNew = (picture) ->
      new Date(picture.fetched_at) > new Date($scope.album.last_visited_inbox_at)

    $scope.displayNoPicturesNotification = ->
      $scope.requestsLimitReached or not ($scope.loadingPictures or $scope.olderPicturesExist)

    $scope.noPicturesNotification = ->
      if $scope.requestsLimitReached
        "We are sorry, but we cannot fetch any more pictures at the moment due to Instagram's hourly limits."
      else if $scope.pictures.length
        "There are no more pictures."
      else
        "We are sorry, but there are no pictures in defined criteria."

    $scope.loadMorePictures = ->
      if $scope.olderPicturesExist and not $scope.loadingPictures
        $scope.loadingPictures = true
        $scope.closeNewPicturesNotification()
        Album.fetchOldInstagramPictures { album_id: albumId }, (data) ->
          $scope.loadingPictures = false
          $scope.olderPicturesExist = data.older_pictures_exist
          $scope.requestsLimitReached = data.requests_limit_reached
          $scope.pictures.push(data.pictures...)
          $scope.addPicturesMarkersOnMap(data.pictures)
        , (error) -> new ErrorMessageService.display

    $scope.fetchNewPictures = ->
      return if $scope.checkingForNewPictures
      $scope.checkingForNewPictures = true
      $scope.closeNewPicturesNotification()
      Album.fetchNewInstagramPictures { album_id: albumId }, (data) ->
        $scope.checkingForNewPictures = false
        $scope.requestsLimitReached = data.requests_limit_reached
        $scope.pictures.push(data.pictures...)
        $scope.addPicturesMarkersOnMap(data.pictures)
      , (error) -> new ErrorMessageService.display

    $scope.addPicturesMarkersOnMap = (pictures) ->
      angular.forEach pictures, (picture) ->
        location = picture.location
        if location?
          $scope.mapMarkers.push
            idKey: picture.id
            coords: 
              latitude:  location.latitude
              longitude: location.longitude
      , (error) -> new ErrorMessageService.display

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

    $scope.acceptPicture = (pictureId) ->
      picture = findPictureById(pictureId)
      picture.status = "accepted"
      Album.acceptPicture { album_id: albumId, picture_id: pictureId }, null, (data) -> ,
      (error) -> picture.changeStatusError = true

    $scope.loadPictureById = (pictureId) ->
      $scope.picture = findPictureById(pictureId)
      $scope.likeItText = $scope.createLikeItTextFor($scope.picture)
      InstagramUser.get { id: $scope.picture.user.id }, (user) ->
        $scope.user = user

    findPictureById = (pictureId) ->
      _.findWhere $scope.pictures, { id: pictureId }

    $scope.isAccepted = (picture) ->
      picture.status is "accepted"

    $scope.denyPicture = (pictureId) ->
      picture = findPictureById(pictureId)
      picture.status = "denied"
      Album.denyPicture { album_id: albumId, picture_id: pictureId }, null, (data) -> ,
      (error) -> picture.changeStatusError = true

    $scope.isDenied = (picture) ->
      picture.status is "denied"

    $scope.acceptAllPictures = ->
      $scope.showConfirmationLoader = true
      Album.acceptAllPictures { album_id: albumId }, null, (data) -> 
        for picture in $scope.pictures
          picture.status = "accepted" if not (picture.status is "denied")
        $scope.showConfirmationLoader = false
        $scope.closeModalBox()
      , (error) -> 
        $scope.showConfirmationLoader = false
        $scope.closeModalBox()
        new ErrorMessageService.display

    $scope.denyAllPictures = ->
      $scope.showConfirmationLoader = true
      Album.denyAllPictures { album_id: albumId }, null, (data) ->
        for picture in $scope.pictures
          picture.status = "denied" if not (picture.status is "accepted")
        $scope.showConfirmationLoader = false
        $scope.closeModalBox()
      , (error) -> 
        $scope.showConfirmationLoader = false
        $scope.closeModalBox()
        new ErrorMessageService.display

    $scope.createLikeItTextFor = (picture) -> WhoLikesPictureText.generate(picture)

    $scope.closeModalBox = ->
      $.fancybox.close()

    $scope.closeNewPicturesNotification = ->
      $scope.showNewPicturesNotification = false
      $timeout $scope.notifyAboutNewPictures, 300000

    $scope.refresh = ->
      $route.reload()
  ]
