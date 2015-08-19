source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
gem 'actionpack-action_caching'
# Hydra stack
gem 'nokogiri', '~> 1.6.3'
gem 'blacklight', '~> 5.7.2'
gem 'hydra-head', '~>7'

# Columbia Hydra models
gem 'cul_hydra', '>= 1.0.7'
#gem 'cul_hydra', :path => '../cul_hydra'
#gem 'cul_omniauth', '~>0.4.1'
gem 'cul_omniauth', :git=>'git://github.com/cul/cul_omniauth.git', :branch=>'master'
gem 'active-triples', '~> 0.2.2'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# Use mysql2 gem for mysql connections
gem 'mysql2', '0.3.18'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.0'

# Use colorbox-rails gem for dialogs
gem 'colorbox-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', '>= 0.12.1',  platforms: :ruby
gem 'libv8', '>= 3.16.14.7' # Min version for compiling on Mac OS 10.10

# Use jquery as the JavaScript library
gem 'jquery-rails', '>= 3.0'
gem 'jquery-ui-rails'

# Pretty printing
gem 'coderay'

# Use resque for background jobs
#gem 'resque', '~> 2.0.0.pre.1', github: 'resque/resque'
gem 'resque', '~> 1.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'bootstrap-sass', '>= 3.2'

gem 'leaflet-rails'

gem 'leaflet-markercluster-rails'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
gem 'capistrano', '~> 2.12.0', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem "devise"
gem "devise-guests", "~> 0.3"

group :development, :test do
  gem "rspec-rails"
  gem "jettywrapper"
end

# Use Thin for local development
#gem "thin"
