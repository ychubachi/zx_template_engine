set :application, "zx_template_engine"
set :repository,  "git@github.com:ychubachi/zx_template_engine.git"
set :deploy_to, "/home/rails/zx_template_engine"
set :use_sudo, false

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "kirin.chubachi.net"                          # Your HTTP server, Apache/etc
role :app, "kirin.chubachi.net"                          # This may be the same as your `Web` server
role :db,  "kirin.chubachi.net", :primary => true # This is where Rails migrations will run

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

#If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
