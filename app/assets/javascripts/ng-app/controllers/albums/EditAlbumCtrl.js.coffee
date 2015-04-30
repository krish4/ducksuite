angular
  .module 'DucksuiteApp'
  .controller 'EditAlbumCtrl', ['$scope', '$http', 'Album', 'ErrorMessageService', ($scope, $http, Album, ErrorMessageService) ->

    $scope.addHashtag = (hashtagsString) ->
      if hashtagsString?
        hashtagsArray = hashtagsString.split(" ")
        for hashtag in hashtagsArray
          if $scope.album.hashtags.indexOf(hashtag) == -1
            $scope.album.hashtags.push(hashtag)
        $scope.hashtag = ""

    $scope.removeHashtag = (hashtag) ->
      index = $scope.album.hashtags.indexOf(hashtag)
      $scope.album.hashtags.splice(index, 1)

    $scope.updateAlbum = ($event, form) ->
      if form.$valid 
        if $scope.album.location_attributes? and $scope.album.location_attributes.name?
          $scope.album.location_attributes.radius     =  $scope.map.circle.radius
          $scope.album.location_attributes.latitude   =  $scope.map.circle.center.latitude
          $scope.album.location_attributes.longitude  =  $scope.map.circle.center.longitude
        else
          $scope.album.location_attributes = {}

        if $scope.album.hashtags.length > 0
          Album.update { id: $scope.album.id }, { album: $scope.album }, (data) ->
            $.fancybox.close()
            $scope.refresh() if $scope.refresh?
          , (error) -> new ErrorMessageService.display

      $event.preventDefault()
  ]

