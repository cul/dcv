class IfpController < SubsitesController
  include Ifp::OfficeData

  configure_blacklight do |config|
    Dcv::Configurators::IfpBlacklightConfigurator.configure(config)
  end

  def index
    if has_search_parameters?
      super
    else
      @ifp_office_sidebar_data = ifp_office_sidebar_data
      render 'home'
    end
  end
 
  def partner
    #if params[:key].index('..') == nil && File.exists?(Rails.root.join("app", "views", 'ifp/partner', "#{params[:key]}.html.erb")) 
      #partial_file_path = 'ifp/partner/'+params[:key]
    if params[:key].index('..') == nil && view_context.ifp_partner_data(params[:key]) 
      partial_file_path = 'ifp/partner/index'
      @ifp_office_sidebar_data = ifp_office_sidebar_data
      render partial_file_path
    else
      render 'ifp/partner/not_found'
    end
  end

  def about_the_ifp
  end

  def about_the_collection
  end

end
