angular
  .module 'DucksuiteApp'
  .factory 'User', ($resource) ->
    $resource "/api/users/:id", null,
      create:
        method: 'POST'
        url: "/api/users"
      update:
        method: 'PUT'
      info:
        method: 'GET'
        url: "/api/users/:id/info"
      open:
        method: 'POST'
        url: "/api/users/:id/open"
      close:
        method: 'POST'
        url: "/api/users/:id/close"