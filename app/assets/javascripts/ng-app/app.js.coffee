app = angular.module('DucksuiteApp', ['ngRoute', 'ngResource', 'Devise', 'google-maps', 'infinite-scroll', 'ngAutocomplete', 'ngAnimate', 'ngClipboard', 'templates'])

app.config(['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
  $routeProvider
    
    # Home
    .when '/', 
      templateUrl: 'dashboard.html'
      controller: 'DashboardCtrl'

    # Albums
    .when '/albums',
      templateUrl: 'albums/index.html'
      controller: 'AlbumsCtrl'
    .when '/albums/:albumId',
      templateUrl: 'albums/show.html'
      controller: 'ShowAlbumCtrl'
    .when '/albums/:albumId/inbox',
      templateUrl: 'albums/inbox.html'
      controller: 'InboxAlbumCtrl'

    # Account
    .when '/login',
      templateUrl: 'login.html'
      controller: 'LoginUserCtrl'
    
    # User settings
    .when '/settings',
      templateUrl: 'users/settings.html'
      controller: 'UpdateUserCtrl'
    .when '/settings/auth/instagram',
      templateUrl: 'users/settings.html'
      controller: 'UpdateUserCtrl'

    # Users
    .when '/users',
      templateUrl: 'users/index.html'
      controller: 'UsersCtrl'
    
    .otherwise
      redirectTo: '/'

  $locationProvider.html5Mode true
])

$ ->
  $('.fancybox').fancybox
    hideOnContentClick: false
    padding: 0
    type: 'inline'

  $('.new-album-btn.fancybox').fancybox
    hideOnContentClick: false
    padding: 0
    type: 'inline'
    helpers: 
      overlay: 
        closeClick: false

  $('.prompt-fancybox').fancybox
    hideOnContentClick: false
    type: 'inline'
    closeBtn: false