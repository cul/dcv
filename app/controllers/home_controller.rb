# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class HomeController < ApplicationController

  include Blacklight::Catalog
  include Hydra::Controller::ControllerBehavior
  include Dcv::Catalog::SearchParamsLogicBehavior
  include Dcv::Catalog::BrowseListBehavior
  include Dcv::Catalog::DateRangeSelectorBehavior
  include Dcv::Catalog::RandomItemBehavior
  include Dcv::Catalog::ModsDisplayBehavior

  # These before_filters apply the hydra access controls
  #before_filter :enforce_show_permissions, :only=>:show
  # This applies appropriate access controls to all solr queries
  #CatalogController.solr_search_params_logic += [:add_access_controls_to_solr_params]

  layout 'dcv'

  configure_blacklight do |config|
    DcvBlacklightConfigurator.configure(config)
  end

  # Overrides the Blacklight::Controller provided #search_action_url.
  # By default, any search action from a Blacklight::Catalog controller
  # should use the current controller when constructing the route.
  def search_action_url options = {}
    url_for(options.merge(:action => 'index', :controller=>'catalog'))
  end

  def index
    if Rails.env == 'development' || ! Rails.cache.exist?(BROWSE_LISTS_KEY)
      refresh_browse_lists_cache
    end
    @browse_lists = Rails.cache.read(BROWSE_LISTS_KEY)

    number_of_items_to_show = 8

    # Don't rely on @browse_lists for the repository values because they might be removed at some point
    repositories_and_counts = get_all_facet_values_and_counts('lib_repo_short_ssim')['value_pairs']
    if repositories_and_counts.length > number_of_items_to_show
      selected_repository_keys = repositories_and_counts.keys.shuffle[0, number_of_items_to_show]
    else
      selected_repository_keys = repositories_and_counts.keys
    end

    rsolr = RSolr.connect :url => YAML.load_file('config/solr.yml')[Rails.env]['url']

    list_of_ids_to_retrieve = []

    selected_repository_keys.each do |repository_key|
      repository_to_query = repository_key
      expected_response_count = repositories_and_counts[repository_key]

      # Do solr query for each repository
      response = rsolr.get 'select', :params => {
        :q  => '*:*',
        :fl => 'id',
        :qt => 'search',
        :fq => [
          'lib_repo_short_ssim:"' + repository_to_query + '"', # Need quotes because values can contain spaces
          '-active_fedora_model_ssi:GenericResource' # Not retrieving file assets
        ],
        :rows => 1,
        :facet => false,
        :start => Random.new.rand(0..expected_response_count-1)
      }

      docs = response['response']['docs']

      if docs.length > 0
        # Append single document id to list_of_ids_to_retrieve
        list_of_ids_to_retrieve << docs[0]['id']
      end
    end

    @do_not_link_to_search = true
    if list_of_ids_to_retrieve.present?
      (@response, @document_list) = get_search_results({:per_page => number_of_items_to_show}, {:fq => 'id:(' + list_of_ids_to_retrieve.map{|id| id.gsub(':', '\:')}.join(' OR ') + ')'})
    else
      @document_list = []
    end
  end

end
