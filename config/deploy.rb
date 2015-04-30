def slack_message
  require 'active_support/core_ext/integer/inflections'

  date_time           = fetch(:release_timestamp) { DateTime.now }
  parsed_date         = DateTime.parse date_time
  ordinalized_day     = parsed_date.day.ordinalize
  formatted_date_time = parsed_date.strftime("%H:%M:%S, on %B the #{ordinalized_day}, %Y")
  "Branch #{fetch(:branch)} was deployed to production at #{formatted_date_time} by #{local_user}."
end


#equire "bundler/capistrano"
require 'capistrano/rvm'
server "52.17.194.53", roles: [:app, :web, :db], :primary => true 
#erver "52.17.194.53", :web, :app, :db, primary: true

set :name,                'ducksuite'
set :repo_url,            "git@github.com:woumedia/ducksuite-project.git"
set :port,                3000
set :application,         fetch(:name)
set :rails_env,           :production
set :deploy_to,           "/home/#{fetch(:name)}/app"
set :user,                fetch(:name)
set :use_sudo,            false
set :pty,                 true
set :default_env,         { path: "/home/#{fetch(:name)}/ruby/bin:/home/#{fetch(:name)}/nodejs/bin:/usr/pgsql-9.3/bin/:$PATH", rails_env: fetch(:rails_env) }
set :bundle_flags,        '--deployment'
set :linked_dirs,         %w(log tmp/pids tmp/cache tmp/sockets)
set :linked_files,        %w(config/application.yml)
set :puma_bind,           %W(tcp://0.0.0.0:#{fetch(:port)} unix://#{shared_path}/tmp/sockets/puma_#{fetch(:name)}.sock)
set :slack_webhook_url,   'https://hooks.slack.com/services/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'
set :slack_options,       -> do { channel: '#ducksuite-notificatio', icon_emoji: ':sheep:', username: fetch(:name), text: slack_message } end
set :linked_files,        %w(config/application.yml)
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

namespace :deploy do
  desc 'Copy environment variables config'
  before :check, :scp do
    on roles :all do
      fetch(:linked_files).each do |file|
        if File.exist? file
          execute :mkdir, '-p', "#{shared_path}/#{File.dirname(file)}"
          upload! file, "#{shared_path}/#{file}"
        else
          puts "#{file} is missing!"
        end
      end
    end
  end

  desc 'Enable systemd service to start puma on boot'
  after :finished, :enable do
    on roles :all do
      execute :sudo, :systemctl, :enable, "/etc/systemd/system/#{fetch(:user)}.service"
      execute :sudo, :systemctl, :'daemon-reload'
    end
  end
end
