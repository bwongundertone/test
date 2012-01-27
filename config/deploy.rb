set :application, "set your application name here"
set :repository,  "set your repository location here"

set :scm, :subversion
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "your web-server here"                          # Your HTTP server, Apache/etc
role :app, "your app-server here"                          # This may be the same as your `Web` server
role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
 


desc "Push Nagios to Production"
  task :push_nagios, :on_error => :continue   do
    puts "Push One"
    run "ssh -A root@stgnagios.undertone.net 'cd /usr/local/internal.git/ && git pull && git add * && git commit -F /usr/local/internal.git/nagios/server/gitcommit && git push'"
    puts "Rsync to prd-ui01"
    run "ssh -A root@stgnagios.undertone.net 'cd /usr/local/internal.git/nagios/server/ && rsync --delete -vrptgoD nagios* cld-util01.undertone.int:/usr/local/nagios/ '"
    puts "Restart Nagios"

