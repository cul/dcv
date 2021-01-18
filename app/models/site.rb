require 'csv'
class Site < ActiveRecord::Base
	include Dcv::Sites::Constants
	include Blacklight::Configurable
	has_many :nav_links, dependent: :destroy
	has_many :site_pages, dependent: :destroy
	accepts_nested_attributes_for :nav_links
	attribute :search_configuration, Site::SearchConfiguration::Type.new, default: -> {Site::SearchConfiguration.new}
	serialize :editor_uids, Array
	serialize :image_uris, Array

	validates :search_type, inclusion: { in: VALID_SEARCH_TYPES }
	validates :layout, inclusion: { in: VALID_LAYOUTS }

	configure_blacklight do |config|
		Dcv::Configurators::DcvBlacklightConfigurator.configure_default_solr_params(config)

		Dcv::Configurators::DcvBlacklightConfigurator.default_paging_configuration(config)

		# solr field configuration for search results/index views
		Dcv::Configurators::DcvBlacklightConfigurator.default_index_configuration(config)

		Dcv::Configurators::DcvBlacklightConfigurator.default_show_configuration(config)

		Dcv::Configurators::DcvBlacklightConfigurator.configure_index_fields(config)

		Dcv::Configurators::DcvBlacklightConfigurator.configure_show_fields(config)
		field_name = ActiveFedora::SolrService.solr_name('lib_repo_short', :symbol, type: :string)
		config.show_fields[field_name].link_to_search = false
		field_name = ActiveFedora::SolrService.solr_name('lib_project_full', :symbol)
		config.show_fields[field_name].link_to_search = false

		Dcv::Configurators::DcvBlacklightConfigurator.configure_citation_fields(config)
		Dcv::Configurators::DcvBlacklightConfigurator.configure_sort_fields(config)
	end

	def initialize(atts = {})
		super
		@search_configuration ||= Site::SearchConfiguration.new(atts.fetch('search_configuration', {}))
		self.search_type ||= DEFAULT_SEARCH_TYPE
	end

	def routing_params(args = {})
		if self.search_type == SEARCH_LOCAL
			args.reject { |k,v| k.to_s == 'slug' }.merge(controller: '/sites/search', site_slug: self.slug)
		else
			search_controller_path = (self.search_type == SEARCH_CATALOG) ? '/catalog': "/#{self.slug}"
			args.reject { |k,v| k.to_s == 'slug' }.merge(controller: search_controller_path)
		end
	end

	def configure_blacklight!
		configure_blacklight do |config|
			config.default_solr_params[:fq] += default_fq()
			config.show.route = self.routing_params
			if self.search_type == SEARCH_LOCAL
				config.document_unique_id_param = :ezid_doi_ssim
				config.show.route = ShowRouteFactory.new(self)
			else
				config.show.route = self.routing_params
			end
			if self.search_type == SEARCH_LOCAL && self.search_configuration.facets.present?
				self.search_configuration.facets.each do |facet|
					facet.configure(config)
				end
			else
				Dcv::Configurators::DcvBlacklightConfigurator.configure_facet_fields(config)
			end
			Dcv::Configurators::DcvBlacklightConfigurator.default_facet_configuration(config, geo: self.search_configuration.map_configuration.enabled)
			if  self.search_type == SEARCH_LOCAL && self.search_configuration.search_fields.present?
				self.search_configuration.search_fields.each do |search_field|
					search_field.configure(config)
				end
			else
				Dcv::Configurators::DcvBlacklightConfigurator.configure_keyword_search_field(config)
			end
		end
	end

	def configure_blacklight(*args, &block)
		blacklight_config.configure(*args, &block)
	end

	def image_uri(refresh = false)
		return image_uris.first if image_uris.length < 2
		@image_uri_memo = nil if refresh
		@image_uri_memo ||= image_uris.sample
	end

	def default_filters
		f = {}
		self.search_configuration.scope_constraints.each do |search_scope, facet_value|
			next unless facet_value.present?
			case search_scope
			when 'collection'
				facet_field = 'lib_collection_sim'
			when 'collection_key'
				facet_field = 'collection_key_ssim'
			when 'project'
				facet_field = 'lib_project_short_ssim'
			when 'project_key'
				facet_field = 'project_key_ssim'
			when 'publisher'
				facet_field = 'publisher_ssim'
			end
			next unless facet_field
			f[facet_field] = Array(facet_value)
		end
		if self.restricted.present?
			f['lib_repo_code_ssim'] = [self.repository_id]
		end
		f
	end

	def default_fq
		default_filters().map do |f,v|
			v = v.map {|v| "\"#{v}\""}.join(" OR ")
			"#{f}:(#{v})"
		end
	end

	def nav_menus
		sorted_links = nav_links.sort { |a,b| (a.sort_group == b.sort_group) ? a.sort_label.to_s <=> b.sort_label.to_s : a.sort_group.to_s <=> b.sort_group.to_s }
		grouped_links = []
		sorted_links.each do |link|
			if grouped_links.empty? || grouped_links[-1]&.sort_label != link.sort_group
				grouped_links << NavMenu.new(link.sort_group)
			end
			grouped_links[-1].links << link
		end
		grouped_links
	end

	# this setter is necessary for the form builder
	def nav_menus_attributes=(attributes)
	end

	def constraints
		self.search_configuration.scope_constraints
	end

	def constraints=(val)
		self.search_configuration.scope_constraints = val
	end

	# patch for Rails 4 store, which doesn't have suffixes
	def publisher_constraints=(constraints)
		self.search_configuration.scope_constraints['publisher'] = Array(constraints)
	end

	def publisher_constraints
		self.search_configuration.scope_constraints['publisher']
	end

	# patch for Rails 4 store, which doesn't have suffixes
	def collection_constraints=(constraints)
		self.search_configuration.scope_constraints['collection'] = Array(constraints)
	end

	def collection_constraints
		self.search_configuration.scope_constraints['collection']
	end

	# patch for Rails 4 store, which doesn't have suffixes
	def collection_key_constraints=(constraints)
		self.search_configuration.scope_constraints['collection_key'] = Array(constraints)
	end

	def collection_key_constraints
		self.search_configuration.scope_constraints['collection_key']
	end

	# patch for Rails 4 store, which doesn't have suffixes
	def project_constraints=(constraints)
		self.search_configuration.scope_constraints['project'] = Array(constraints)
	end

	def project_constraints
		self.search_configuration.scope_constraints['project']
	end

	# patch for Rails 4 store, which doesn't have suffixes
	def project_key_constraints=(constraints)
		self.search_configuration.scope_constraints['project_key'] = Array(constraints)
	end

	def project_key_constraints
		self.search_configuration.scope_constraints['project_key']
	end

	def about_link
		nav_links.detect {|link| link.about_link? }
	end

	def banner_uploader
		@banner_uploader ||= BannerUploader.new(self)
	end

	def has_banner_image?
		File.exists?(banner_uploader.store_path)
	end

	def banner_url
		banner_uploader.store_path.sub(File.join(Rails.root, 'public'), '')
	end

	def watermark_uploader
		@watermark_uploader ||= WatermarkUploader.new(self)
	end

	def has_watermark_image?
		File.exists?(watermark_uploader.store_path)
	end

	def watermark_url
		watermark_uploader.store_path.sub(File.join(Rails.root, 'public'), '')
	end

	def to_subsite_config
		config = {
			'slug' => slug, 'restricted' => slug =~ /restricted/, 'palette' => palette, 'layout' => layout
		}
		SubsiteConfig.for_path(slug, slug =~ /restricted/).merge(config).merge(search_configuration.as_json).with_indifferent_access
	end

	def attributes
		super.tap do |atts|
			atts.delete('constraints')
			atts['search_configuration'] = @search_configuration.as_json
		end
	end

	class ShowRouteFactory
		def initialize(site)
			@slug = site.slug.split('/')[-1]
			@restricted = site.slug =~ /restricted/
		end
		def doi_params(doc)
			return {} unless doc
			doi_id = doc.fetch('ezid_doi_ssim',[]).first&.sub(/^doi:/,'')
			{ id: doi_id }
		end
		def merge opts = {}
			controller_name = "/sites/search"
			controller_name = "/restricted#{controller_name}" if @restricted
			doc = opts[:id]
			doi_params(doc).merge(controller: controller_name, action: :show, site_slug: @slug)
		end
	end
end