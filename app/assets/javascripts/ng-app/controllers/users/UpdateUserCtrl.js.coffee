angular
  .module 'DucksuiteApp'
  .controller 'UpdateUserCtrl', ['$scope', '$http', '$routeParams', 'User', 'Auth', 'Domain', 'ErrorMessageService', ($scope, $http, $routeParams, User, Auth, Domain, ErrorMessageService) ->

    # Tabs
    $scope.currentTab = "general"
    $scope.changeTab = (tab) ->
      $scope.currentTab = tab

    # Get current user
    $scope.data = 
      user: {}
      authentications: {}

    $scope.new_domain = {}

    Auth.currentUser().then (user) ->
      $scope.userId = user.id
      User.get { id: $scope.userId }, (data) ->
        $scope.data.user.name = data.user.name
        $scope.data.user.email = data.user.email
        $scope.data.user.brand = data.user.brand
        $scope.data.user.domains = data.user.domains
        $scope.data.authentications = data.authentications
      , (error) -> new ErrorMessageService.display

    # General settings
    $scope.submit = ->
      return if $scope.data.password isnt null and $scope.data.user.password != $scope.password_confirmation
      User.update { id: $scope.userId }, $scope.data, ->
        $scope.flashMessage = {type: 'success', message: 'Settings has been updated successfully'}
      , (error) -> new ErrorMessageService.display

    # My Apps
    $scope.addDomain = ->
      Domain.create { name: $scope.new_domain.name, user_id: $scope.userId }, (data) ->
        $scope.flashMessage = {type: 'success', message: 'Domain has been added successfully'}
        $scope.data.user.domains.push(data)
        $scope.new_domain.name = ''
      , (error) -> new ErrorMessageService.display

    $scope.removeDomain = (index)->
      domain = $scope.data.user.domains[index]
      Domain.remove { id: domain.id }, (data) ->
        $scope.flashMessage = {type: 'success', message: 'Domain has been removed successfully'}
        $scope.data.user.domains.splice(index, 1)
      , (error) -> new ErrorMessageService.display
  ]
