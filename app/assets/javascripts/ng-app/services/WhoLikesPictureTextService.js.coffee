# It returns text who likes the picture. 
# e.g. "tomolum, valeeeries, ttarekk and 11 others like this."

WhoLikesPictureText = ->

  generate: (picture) ->
    
    likes = picture.likes
    text = ""

    if likes.count is 0
      text = "Nobody likes it yet."

    else if likes.count is 3
      # # Produces: "tomolum, valeeeries and ttarekk like this."
      text += likes.data[0].username + ", " + likes.data[1].username + " and " + likes.data[2].username
      text += " like this."

    else
      # Produces "tomolum, valeeeries, ttarekk"
      for i in [0..2]
        text += likes.data[i].username + ", " if likes.data[i] isnt undefined
      text = text.slice(0, -2) # it removes the last comma

      if likes.count > 3
        # Produces "tomolum, valeeeries, ttarekk and 10"
        text += " and " + (likes.count - 3)

        if likes.count == 4
          # Produces: "tomolum, valeeeries, ttarekk and 1 other"
          text += " other"
        else
          # Produces: "tomolum, valeeeries, ttarekk and 10 others", where 10 is a number of other people.
          text += " others"

      # Produces full text: "tomolum, valeeeries, ttarekk and 10 others like this."
      text += " like this."

    text

angular
  .module 'DucksuiteApp'
  .factory 'WhoLikesPictureText', [WhoLikesPictureText]