set :rails_env, "dcv_private_dev"
set :application, "dcv_private_dev"
set :domain,      "bronte.cul.columbia.edu"
set :deploy_to,   "/opt/passenger/#{application}/"
set :user, "deployer"
set :scm_passphrase, "Current user can full owner domains."

role :app, domain
role :web, domain
role :worker, domain
role :db,  domain, :primary => true
