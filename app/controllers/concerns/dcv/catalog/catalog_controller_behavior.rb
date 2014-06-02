module Dcv::Catalog::CatalogControllerBehavior
  extend ActiveSupport::Concern

  BROWSE_LISTS_KEY = 'browse_lists'

  included do
    CatalogController.solr_search_params_logic += [:file_assets_filter]
  end
  
  # GET #root
  def home
    unless Rails.cache.exist?(BROWSE_LISTS_KEY)
      refresh_browse_lists_cache
    end
    @browse_lists = Rails.cache.read(BROWSE_LISTS_KEY)
  end
  
  # Browse List Logic

  def refresh_browse_lists_cache
    Rails.cache.write(BROWSE_LISTS_KEY, get_browse_lists);
  end

  def get_browse_lists
    list_facets = [
      'lib_name_sim',
      'lib_format_sim',
      'lib_repo_sim'
    ]

    hash_to_return = {}

    list_facets.each do |facet_name|
      hash_to_return[facet_name] = {
        'value1' => '1',
        'value2' => '2',
        'value3' => '3',
        'value4' => '4'
      }
    end

    return hash_to_return
  end
  
  # CatalogController.solr_search_params_logic Additions
  
  def file_assets_filter(solr_parameters, user_parameters)
    unless user_parameters[:show_file_assets] == 'true'
      solr_parameters[:fq] << '-active_fedora_model_ssi:GenericResource'
    end
  end

end
