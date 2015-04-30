angular
  .module 'DucksuiteApp'
  .factory 'Album', ($resource) ->
    $resource "/api/albums/:id", null,
      update: 
        method: 'PUT'
      fetchOldInstagramPictures:
        method: 'GET'
        url: '/api/albums/:album_id/pictures/fetch_old_instagram_pictures'
      fetchNewInstagramPictures:
        method: 'GET'
        url: '/api/albums/:album_id/pictures/fetch_new_instagram_pictures'
      getPictures:
        method: 'GET'
        url: '/api/albums/:album_id/pictures'
        isArray: true
      getInboxPictures:
        method: 'get'
        url: '/api/albums/:album_id/pictures/inbox_pictures'
        isArray: true
      getPicture:
        method: 'GET'
        url: "/api/albums/:album_id/pictures/:picture_id"
      acceptPicture:
        method: 'POST'
        url: '/api/albums/:album_id/pictures/:picture_id/accept'
      acceptAllPictures:
        method: 'POST'
        url: '/api/albums/:album_id/pictures/accept_all'
      denyPicture:
        method: 'POST'
        url: '/api/albums/:album_id/pictures/:picture_id/deny'
      denyAllPictures:
        method: 'POST'
        url: '/api/albums/:album_id/pictures/deny_all'
      removePicture:
        method: 'DELETE'
        url: '/api/albums/:album_id/pictures/:picture_id'
