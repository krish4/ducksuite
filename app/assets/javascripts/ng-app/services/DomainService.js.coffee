angular
  .module 'DucksuiteApp'
  .factory 'Domain', ($resource) ->
    $resource "/api/domains", null,
      create:
        method: 'POST'
      remove: 
        method: 'DELETE'
        url: "/api/domains/:id"
