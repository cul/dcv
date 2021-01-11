class Site::FacetConfiguration
	include ActiveModel::Dirty
	include ActiveModel::Serializers::JSON
	include ActiveRecord::AttributeAssignment

	VALID_VALUE_TRANSFORMS = ['capitalize', 'singularize', 'translate'].freeze
	ATTRIBUTES = [:exclusions, :field_name, :label, :limit, :sort, :value_map, :value_transforms].freeze

	define_attribute_methods *ATTRIBUTES
	attr_accessor *ATTRIBUTES

	def default_configuration
		{ limit: 10, sort: :index, value_transforms: [] }
	end

	def initialize(atts = {})
		atts = default_configuration.merge(atts.symbolize_keys).with_indifferent_access
		assign_attributes(atts)
		clear_changes_information
	end

	def exclusions=(val)
		val = Array(val).compact
		exclusions_will_change! unless val == @exclusions
		@exclusions = val
	end

	def value_transforms=(val)
		val = clean_and_freeze_transform_array(val)
		value_transforms_will_change! unless val == @value_transforms
		@value_transforms = val
	end

	def eql?(obj)
		return false unless obj.is_a? ::Site::FacetConfiguration
		as_json.eql?(obj.as_json)
	end

	def attributes
		as_json
	end

	def serializable_hash(opts = {})
		{
			'exclusions' => @exclusions,
			'field_name' => @field_name,
			'label' => @label,
			'limit' => @limit,
			'sort' => @sort,
			'value_map' => @value_map,
			'value_transforms' => @value_transforms || []
		}.tap {|v| v.compact! if opts&.fetch(:compact, false)}
	end

	private
		def clean_and_freeze_transform_array(val)
			(Array(val).compact.map(&:to_s) & VALID_VALUE_TRANSFORMS).freeze
		end
end