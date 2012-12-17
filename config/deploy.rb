set :application, "Mum"
set :repository,  "git@github.com:psenthu/mum.git"

set :scm, :git
default_run_options[:pty] = true
set :user, "deployer"
set :branch, "master"

set :user_sudo, false
ssh_options[:forward_agent] = true


set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "mapi.thembase.co.uk"                          # Your HTTP server, Apache/etc
role :app, "mapi.thembase.co.uk"                          # This may be the same as your `Web` server
role :db,  "mapi.thembase.co.uk", :primary => true # This is where Rails migrations will run
role :db,  "mapi.thembase.co.uk"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end