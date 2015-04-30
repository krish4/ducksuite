angular
  .module 'DucksuiteApp'
  .controller 'AuthUserCtrl', ['$scope', '$routeParams', '$http', 'Auth', 'User', 'ConnectToInstagram', ($scope, $routeParams, $http, Auth, User, ConnectToInstagram) ->

    $scope.connectToInstagramURL = ConnectToInstagram.getURL()

    Auth.currentUser().then (user) ->
      $scope.userId = user.id

      # Social profiles
      User.get { id: $scope.userId }, (data) ->
        for auth in data.authentications
          switch auth.provider
            when "instagram" then $scope.isInstagramAuth = true
            when "facebook" then $scope.isFacebookAuth = true

      # Instagram authentication
      authCode = $routeParams.code
      if authCode? and $scope.userId?
        $scope.$parent.currentTab = "social"
        $http.post('/api/users/' + $scope.userId + '/instagram/auth', { code: authCode }).success (data) ->
          $scope.isInstagramAuth = true

    $scope.closeWindow = ->
      $.fancybox.close()
  ]

