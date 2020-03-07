class LehmanController < SubsitesController
  include ActionController::Live

  configure_blacklight do |config|
    Dcv::Configurators::LehmanBlacklightConfigurator.configure(config)
    # Include this target's content in search results, and any additional publish targets specified in subsites.yml
    publishers = [subsite_config['uri']] + (subsite_config['additional_publish_targets'] || [])
    config.default_solr_params[:fq] << "publisher_ssim:(\"" + publishers.join('" OR "') + "\")"
  end

  def index
    if request.format.csv?
      stream_csv_response_for_search_results
    else
  	  super
      unless has_search_parameters?
        render 'home'
      end
    end
  end

  def about
  end

  def faq
  end

  private

  def document_to_csv_row(document, field_keys_to_labels)
    field_keys_to_labels.keys.map{ |field_key|
      next '' unless document.has?(field_key)
      values = document[field_key]
      # We don't want to include the 'manuscripts' value because other format value is more descriptive
      values.delete('manuscripts') if (field_key == 'lib_format_ssm') && values[1]
      values.first
    }
  end
end
