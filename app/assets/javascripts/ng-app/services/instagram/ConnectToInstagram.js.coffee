ConnectToInstagram = ($location) ->
  getURL: ->
    [host, port, protocol] = [$location.host(), $location.port(), $location.protocol()]
    client_id = gon.client_id
    redirect_uri = protocol + "://" + host
    redirect_uri += ":" + port if port? && port != 80
    "https://api.instagram.com/oauth/authorize/?client_id=" + client_id + "&redirect_uri=" + redirect_uri + "&response_type=code"

angular
  .module 'DucksuiteApp'
  .factory 'ConnectToInstagram', ['$location', ConnectToInstagram]