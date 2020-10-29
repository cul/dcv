# frozen_string_literal: true
module Dcv::Sites
	module Constants
		# import/export structure constants
		SITE_METADATA = "properties.yml"
		IMAGES_SUBDIR = "images"
		PAGES_SUBDIR = "pages"
		# portable layouts
		LAYOUT_GALLERY = 'gallery'
		LAYOUT_PORTRAIT = 'portrait'
		LAYOUT_SIGNATURE = 'signature'
		PORTABLE_LAYOUTS = [LAYOUT_GALLERY, LAYOUT_PORTRAIT, LAYOUT_SIGNATURE].freeze
		# search types
		SEARCH_CATALOG = 'catalog'
		SEARCH_CUSTOM = 'custom'
		SEARCH_LOCAL = 'local'
		VALID_SEARCH_TYPES = [SEARCH_CATALOG, SEARCH_LOCAL, SEARCH_CUSTOM].freeze
		# default property values
		DEFAULT_SEARCH_TYPE = 'catalog' # delegate search and display to general catalog
		DEFAULT_LAYOUT = 'default' # use sitewide default at designers' discretion
		DEFAULT_PALETTE = 'default' # use sitewide default at designers' discretion
	end
	autoload :Export, 'dcv/sites/export'
	autoload :Import, 'dcv/sites/import'
end