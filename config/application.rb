require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dcv
  class Application < Rails::Application

    config.middleware.use Rack::Deflater # Use GZip on responses whenever possible

    config.generators do |g|
      g.test_framework :rspec, :spec => true
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # See: http://stackoverflow.com/questions/4928664/trying-to-implement-a-module-using-namespaces
    config.autoload_paths += %W(#{config.root}/lib)

    # Custom precompiled asset manifests
    config.assets.precompile += [
        'dcv.css',
        'dcv.js',
        'welcome.js', 'welcome.css',
        'print.css',
        'freelib.js',
        'd3.js']

    # And include styles for all subsite layouts
    subsite_data = YAML.load_file("#{Rails.root.to_s}/config/subsites.yml")[Rails.env]
    unique_layouts = []
    unique_layouts += (subsite_data['public'].values || []).map{|prefix| prefix['layout']}
    unique_layouts += (subsite_data['restricted'].values || []).map{|prefix| prefix['layout']}
    unique_layouts.uniq!
    config.assets.precompile += unique_layouts.map{|layout| layout + '.css'}
    config.assets.precompile += unique_layouts.map{|layout| layout + '.js'}

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
