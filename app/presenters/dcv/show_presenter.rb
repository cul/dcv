# frozen_string_literal: true
module Dcv
  class ShowPresenter < Blacklight::ShowPresenter
    def render_document_citation_field_value field, options = {}
      field_config = @configuration.citation_fields[field] || Blacklight::Configuration::NullField.new
      value = options[:value] || field_value(field_config, options)

      field_values(field_config, value: Array(value))
    end

    def render_document_geo_field_value field, options = {}
      field_config = @configuration.geo_fields[field] || Blacklight::Configuration::NullField.new
      value = options[:value] || field_value(field_config, options)

      field_values(field_config, value: Array(value))
    end

    def render_document_dynamic_field_value field, options = {}
      field_config = options.fetch(:field_config, Blacklight::Configuration::NullField.new)
      value = options[:value] || field_value(field_config, options)

      field_values(field_config, value: Array(value))
    end
    ##
    # Create <link rel="alternate"> links from a documents dynamically
    # provided export formats. Returns empty string if no links available.
    #
    # @param [Hash] options
    # @option options [Boolean] :unique ensures only one link is output for every
    #     content type, e.g. as required by atom
    # @option options [Array<String>] :exclude array of format shortnames to not include in the output
    # @deprecated moved to ShowPresenter#link_rel_alternates
    def link_rel_alternates(options = {})
      Dcv::LinkAlternatePresenter.new(view_context, document, options).render
    end
  end
end