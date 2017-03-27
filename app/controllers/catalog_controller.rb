class CatalogController < SubsitesController

  before_action :refresh_catalog_browse_lists_cache, only: [:home, :browse]

  configure_blacklight do |config|
    Dcv::Configurators::DcvBlacklightConfigurator.configure(config)
    # Include this target's content in search results, and any additional publish targets specified in subsites.yml
    publishers = [subsite_config['uri']] + (subsite_config['additional_publish_targets'] || [])
    config.default_solr_params[:fq] << 'publisher_ssim:("' + publishers.join('" OR "') + '")'
    
    # Do not include the catalog publish target or any additional publish targets defined in search results
    config.default_solr_params[:fq] << '-id:("' + publishers.map{|info_fedora_prefixed_pid| info_fedora_prefixed_pid.gsub('info:fedora/', '') }.join('" OR "') + '")'
  end

end
