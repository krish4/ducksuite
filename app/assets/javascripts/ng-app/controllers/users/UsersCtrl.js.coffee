angular
  .module 'DucksuiteApp'
  .controller 'UsersCtrl', ['$scope', 'User', 'ErrorMessageService', ($scope, User, ErrorMessageService) ->

    $scope.currentTab = "users"

    User.query {}, (users) ->
      $scope.users = users
    , (error) -> new ErrorMessageService.display

    $scope.changeTab  = (tab) -> 
      $scope.currentTab = tab

    $scope.openAccount = (user) ->
      User.open { id: user.id }, null, ->
        $scope.flashMessage = { type: 'success', message: 'The account has been opened successfully!' }
        user.closed_at = null
      , (error) -> new ErrorMessageService.display

    $scope.closeAccount = (user) ->
      User.close { id: user.id }, null, ->
        $scope.flashMessage = { type: 'success', message: 'The account has been closed successfully!' }
        user.closed_at = Date.now
      , (error) -> new ErrorMessageService.display

    $scope.goToEditUser = (user) ->
      $scope.changeTab "edit"
      $scope.current_user = user

    $scope.editUser = (user) ->
      User.update { id: user.id }, { user: user }, ->
        $scope.flashMessage = { type: 'success', message: 'The user has been updated successfully!' }
      , (error) -> 
        $scope.flashMessage = { type: 'error', message: 'Not all the fields are correctly filled.' }

    $scope.goToCreateUser = (user) ->
      $scope.changeTab "create"
      $scope.current_user = {}

    $scope.createUser = (user) ->
      User.create { user: user }, (user) ->
        $scope.flashMessage = { type: 'success', message: 'The user has been created successfully!' }
        $scope.users.push(user)
      , (error) -> 
        $scope.flashMessage = { type: 'error', message: 'Not all the fields are correctly filled.' }

  ]
