module ChildrenHelper
  include Blacklight::BlacklightHelperBehavior
  include Blacklight::ConfigurationHelperBehavior
  def children(id=params[:id], opts={})
    # get the document
    @response, @document = get_solr_response_for_doc_id(id)
    # get the model class
    klass = @document['active_fedora_model_ssi'].constantize
    # get a relation for :parts
    reflection = klass.reflect_on_association(:parts)
    association = reflection.association_class.new(IdProxy.new(id), reflection)
    children = {parent_id: id, children: []}
    children[:per_page] = opts.fetch(:per_page, 10).to_i
    children[:page] = opts.fetch(:page, 0).to_i
    offset = children[:per_page] * children[:page]
    rows = children[:per_page]
    fl = ['id']
    title_field = nil
    begin
      fl << (title_field = document_show_link_field).to_s
    rescue
    end
    opts = {fl: fl.join(','), raw: true, rows: rows, start: offset}.merge(opts)
    response = association.load_from_solr(opts)['response'];
    children[:pages] = (response['numFound'].to_f / rows).ceil
    children[:page] = children[:page]
    children[:count] = response['numFound'].to_i
    response['docs'].map do |doc|
      opts = {controller: :thumbs, id: doc['id'], action: :show}
      opts[:only_path] = true 
      child = {id: doc['id'], thumbnail: url_for(opts)}
      if title_field
        title = doc[title_field.to_s]
        title = title.first if title.is_a? Array
        child[:title] = title
      end
      children[:children] << child
    end
    children
  end

  #TODO: replace this with Cul::Scv::Fedora::FakeObject
  class IdProxy
    attr_reader :id
    def initialize(id)
      @id = id
    end

    def internal_uri
      @uri ||= "info:fedora/#{@id}"
    end

    def new_record?
      false
    end
  end
end