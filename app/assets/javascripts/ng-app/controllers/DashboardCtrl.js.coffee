angular
  .module 'DucksuiteApp'
  .controller 'DashboardCtrl', ['$scope', '$http', '$location', '$routeParams', 'Auth', 'User', 'Album', 'NotificationsBuilder', 'ConnectToInstagram', 'ErrorMessageService', ($scope, $http, $location, $routeParams, Auth, User, Album, NotificationsBuilder, ConnectToInstagram, ErrorMessageService) ->

    $scope.connectToInstagramURL = ConnectToInstagram.getURL()

    Auth.currentUser().then (currentUser) ->
      User.info { id: currentUser.id }, (userInfo) ->
        $scope.totalPictures = userInfo.total_pictures
        $scope.newPicturesCount = userInfo.inbox_count

        User.get { id: currentUser.id }, (data) ->
          $scope.brandName = data.user.brand
          if not userInfo.is_authenticated
            displayInstagramAuthModalBox()
            for auth in data.authentications
              switch auth.provider
                when "instagram" then $scope.isInstagramAuth = true
                when "facebook" then $scope.isFacebookAuth = true
            if $routeParams.code?
              $http.post('/api/users/' + currentUser.id + '/instagram/auth', { code: $routeParams.code }).success (data) ->
                $scope.isInstagramAuth = true

    Album.query {}, (albums) ->
      $scope.albums        = albums
      $scope.albumsNumber  = albums.length
      $scope.notifications = NotificationsBuilder.build(albums)
    , (error) -> new ErrorMessageService.display

    $scope.sortNotificationByDate = (notificationItem) -> 
      new Date(notificationItem[0])

    $scope.goToSettings = ->
      $scope.closeWindow()
      $location.path("/settings")

    $scope.closeWindow = ->
      $.fancybox.close()

    $scope.showTotalPicturesSpinner = -> 
      _.isUndefined $scope.totalPictures

    $scope.showNewPicturesSpinner = -> 
      _.isUndefined $scope.newPicturesCount

    $scope.getRecentPictures = (albumId) -> 
      album = findAlbumById(albumId)
      album.recent_pictures

    findAlbumById = (albumId) -> 
      _.findWhere $scope.albums, { id: albumId }

    $scope.showNotificationsSpinner = -> 
      _.isUndefined $scope.notifications
    
    $scope.showNotifications = -> 
      not _.isEmpty $scope.notifications

    $scope.displayBrandName = ->
      if $scope.brandName isnt null then $scope.brandName else "Your brand"

    $scope.redirect = (id) ->
      $location.path("/albums/#{id}/inbox")

    displayInstagramAuthModalBox = ->
      $.fancybox.open
        openSpeed: 500
        closeSpeed: 500
        href: '#connect-to-instagram-modal'

    $scope.setDefaultValuesForAlbum = ->
      $scope.areFiltersVisible = false

    $scope.changeFiltersVisibility = ->
      $scope.areFiltersVisible = !$scope.areFiltersVisible
      $.fancybox.update()

  ]
