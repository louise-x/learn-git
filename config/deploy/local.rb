# typically server config is:
#server 'my.remotehost.com', roles: %w{app web}, user: 'deploy', key: '/path/to/key.pem'
# localhost config is:
#server 'localhost', roles: %w{app web} # no need to set SSH configs.
set :stage, :local
set :rails_env, :local
set :branch, "main"
server "localhost", roles: %w{web app db }