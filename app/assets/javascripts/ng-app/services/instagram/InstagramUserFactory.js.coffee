angular
  .module 'DucksuiteApp'
  .factory 'InstagramUser', ($resource) ->
    $resource "/api/instagram/users/:id", null