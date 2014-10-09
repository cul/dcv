class CatalogController < ApplicationController

  include Dcv::CatalogIncludes

  before_action :refresh_browse_lists_cache, only: [:home, :browse]
  # These before_filters apply the hydra access controls
  #before_filter :enforce_show_permissions, :only=>:show
  # This applies appropriate access controls to all solr queries
  #CatalogController.solr_search_params_logic += [:add_access_controls_to_solr_params]

  layout 'dcv'

  configure_blacklight do |config|
    Dcv::Configurators::DcvBlacklightConfigurator.configure(config)
  end

  def get_solr_response_for_app_id(id=nil, extra_controller_params={})
    id ||= params[:id]
    id.sub!(/apt\:\/columbia/,'apt://columbia') # TOTAL HACK
    id.gsub!(':','\:')
    id.gsub!('/','\/')
    p = blacklight_config.default_document_solr_params.merge(extra_controller_params)
    p[:fq] = "dc_identifier_ssim:#{(id)}"
    solr_response = find(blacklight_config.document_solr_path, p)
    if solr_response.docs.empty?
      # ba2213 thought this was a good interim until we can verify that all docs have DC:identifier set appropriately
      p[:fq] = "identifier_ssim:#{(id)}"
      solr_response = find(blacklight_config.document_solr_path, p)
    end
    raise Blacklight::Exceptions::InvalidSolrID.new if solr_response.docs.empty?
    document = SolrDocument.new(solr_response.docs.first, solr_response)
    @response, @document = [solr_response, document]
  end

  def resolve
    get_solr_response_for_app_id
    action = params.delete(:resolve)
    action.sub!(/s$/,'')
    method_name = action + '_url'
    url = send method_name.to_sym, @document[:id]
    redirect_to url
  end

  def browse
  end

end
