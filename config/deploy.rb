set :application, "zx_template_engine"
set :repository,  "git@github.com:ychubachi/zx_template_engine.git"
set :deploy_to, "/home/rails/zx_template_engine"
set :use_sudo, false

set :scm, :git

role :web, "kirin.chubachi.net"
role :app, "kirin.chubachi.net"
role :db,  "kirin.chubachi.net", :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :deploy do
  desc <<-DESC
    My setup
  DESC
  task :mysetup, :roles => :app do
    src = File.join(deploy_to, 'shared', 'uploads')
    run "mkdir #{src}"
    src = File.join(deploy_to, 'shared', 'generated')
    run "mkdir #{src}"
    src = File.join(deploy_to, 'shared', 'db')
    run "mkdir #{src}"
  end

  desc <<-DESC
    Creates synlinks for this application.
  DESC
  task :mylinks, :roles => :app do
    # Uploads
    src = File.join(deploy_to, 'shared', 'uploads')
    dst = File.join(current_path,'public')
    run "ln -s #{src} #{dst}"
    # Generated
    src = File.join(deploy_to, 'shared', 'generated')
    dst = File.join(current_path,'public')
    run "ln -s #{src} #{dst}"
  end

  desc <<-DESC
    Deploy everything. This will work similarly to the 'migrations' task, 
    but will create the application symlinks.
  DESC
  task :all do
    set :migrate_target, :latest
    update_code
    symlink
    mylinks
    migrate
    restart
  end
end
