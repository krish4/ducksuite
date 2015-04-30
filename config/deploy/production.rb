set :stage, 'production'
server '52.17.194.53', user: 'ubuntu', roles: %i(web app db)
#server '52.17.194.53', user: fetch(:user), roles: %i(web app db)
