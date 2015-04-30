NotificationsBuilder = ->

  getFormattedDate = (date) ->
    moment(date).format "dddd, D MMMM YYYY"

  getAllNotifications = (albums) ->
    notifications = []
    for album in albums
      album_notifications = _.map album.notifications, (elem) ->
        elem.album_id    = album.id
        elem.album_title = album.title
        elem
      notifications.push album_notifications...
    notifications

  groupByDate = (notifications) ->
    _.groupBy notifications, (n) -> 
      getFormattedDate n.created_at

  getFormattedArray = (notifications) ->
    notifsArray = []
    for date, notifs of notifications
      notifsArray.push([date, notifs])
    notifsArray

  build: (albums) ->
    notifications = getAllNotifications albums 
    notifications = groupByDate notifications
    getFormattedArray notifications

angular
  .module 'DucksuiteApp'
  .factory 'NotificationsBuilder', [NotificationsBuilder]