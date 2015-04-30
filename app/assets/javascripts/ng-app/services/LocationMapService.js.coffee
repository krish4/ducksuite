LocationMap = ($q) ->

  geocoder = new google.maps.Geocoder()

  # These coordinates points to Copenhagen.
  defaultPosition = 
    latitude: 55.6760968
    longitude: 12.5683371

  map = 
    control: {}
    draggable: true
    center: defaultPosition
    zoom: 10
    refresh: false
    options:
      streetViewControl: false
      panControl: false
      maxZoom: 20
      minZoom: 1
    circle:
      center: defaultPosition
      radius: 10000
      fill:
        color: '#0bb697'
        opacity: 0.5
      stroke:
        color: '#109b81'
        opacity: 0.5
        weight: 1
      draggable: true
      editable: true
      visible: true
      events: 
        radius_changed: ->
          correctCircleRadius()

  correctCircleRadius = ->
    map.circle.radius = 0 if map.circle.radius < 0

  refreshMap = (positionData, status) ->
    if status is "OK" and positionData?
      currentPosition = positionData[0].geometry.location
      coords = { latitude: currentPosition.lat(), longitude: currentPosition.lng() }
      map.circle.center = coords
      map.control.refresh(coords)

  # Return handling functions for compatibility
  setCenter: (lat, long) ->
    coords = { latitude: lat, longitude: long }
    map.center = map.circle.center = coords
  setCircleRadius: (radius) ->
    map.circle.radius = radius
  geocodeAddress: (location) ->
    geocoder.geocode
      address: location, refreshMap
  map: map

angular
  .module 'DucksuiteApp'
  .factory 'LocationMap', ['$q', LocationMap]