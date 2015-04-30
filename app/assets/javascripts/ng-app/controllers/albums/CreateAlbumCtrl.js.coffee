angular
  .module 'DucksuiteApp'
  .controller 'CreateAlbumCtrl', ['$scope', '$http', 'Auth', 'Album', 'LocationMap', 'ErrorMessageService', ($scope, $http, Auth, Album, LocationMap, ErrorMessageService) ->

    $scope.album = 
      hashtags: []
      location_attributes: {}
    
    Auth.currentUser().then (user) ->
      $scope.album.user_id = user.id

    $scope.map = LocationMap.map

    $scope.geocodeAddress = -> 
      LocationMap.geocodeAddress($scope.album.location_attributes.name)

    $scope.addHashtag = (hashtagsString) ->
      if !!hashtagsString
        hashtagsArray = hashtagsString.split(" ")
        for hashtag in hashtagsArray
          if $scope.album.hashtags.indexOf(hashtag) == -1
            $scope.album.hashtags.push(hashtag)
        $scope.hashtag = ""

    $scope.removeHashtag = (hashtag) ->
      index = $scope.album.hashtags.indexOf(hashtag)
      $scope.album.hashtags.splice(index, 1)

    $scope.createAlbum = (form) ->
      if $scope.album.location_attributes.name
        $scope.album.location_attributes.latitude = $scope.map.circle.center.latitude
        $scope.album.location_attributes.longitude = $scope.map.circle.center.longitude
        $scope.album.location_attributes.radius = $scope.map.circle.radius
      else
        $scope.album.location_attributes = {}

      if form.$valid and $scope.album.hashtags.length > 0
        Album.save { album: $scope.album }, (data) ->
          $.fancybox.close()
          $scope.redirect(data.id) if $scope.redirect?
        , (error) -> new ErrorMessageService.display
  ]

