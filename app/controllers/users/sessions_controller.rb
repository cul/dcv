class Users::SessionsController < Devise::SessionsController
  TRUE_REGEX = /true/i
  SAML_REGEX = /^saml$/i
  # override so that database_authenticatable can be removed
  def new_session_path(scope)
    new_user_session_path
  end
  def omniauth_provider_key
    @omniauth_provider_key ||= Dcv::Application.cas_configuration_opts[:provider]
  end

  # updates the search counter (allows the show view to paginate)
  def update
    if params[:counter]
      session[:search][:counter] = params[:counter] unless session[:search][:counter] == params[:counter]
    end
    if params[:display_members]
      session[:search][:display_members] = params[:display_members] unless session[:search][:display_members] == params[:display_members]
    end

    if params[:id]
      redirect_to :action => "show", :controller => :catalog, :id=>params[:id]
    else
      redirect_to :action => "index", :controller => :catalog
    end
  end

  def after_sign_out_path_for(resource)
    service = (params[:restricted].to_s =~ TRUE_REGEX) ? restricted_url : root_url
    if resource && (resource.provider =~ SAML_REGEX)
      service = Devise.omniauth_configs[:saml].strategy.logout_url(service)
    end
    service
  end
  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
