module SubsiteHelper
  def map_search_settings_for_subsite
    if controller.respond_to? :subsite_config
      controller.subsite_config.fetch('map_search', {})
    else
      {}
    end
  end

  def signature_image_path
    path = File.join("", "images", "sites", @subsite.slug, "signature.svg")
    File.exists?(File.join(Rails.root, "public", path)) ? path : asset_path("signature/signature.svg")
  end

  def signature_banner_image_path
    @signature_banner_image_path ||= begin
      path = File.join("", "images", "sites", @subsite.slug, "signature-banner.png")
      File.exists?(File.join(Rails.root, "public", path)) ? path : asset_path("signature/signature-banner.png")
    end
  end
end
