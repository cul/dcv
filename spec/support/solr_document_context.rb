shared_context "a solr document", shared_context: :metadata do
	let(:document_id) { 'document_id' }
	let(:types) { ['Unknown'] }
	let(:restrictions) { [] }
	let(:slugs) { [] }
	let(:slug) { slugs.first}
	let(:sources) { [] }
	let(:dois) { [] }
	let(:context_urls) { nil }
	let(:solr_data) {  {
			id: document_id, dc_type_ssm: types, source_ssim: sources, restriction_ssim: restrictions,
			slug_ssim: slugs, ezid_doi_ssim: dois, lib_item_in_context_url_ssm: context_urls
		}
	 }
	let(:solr_document) { SolrDocument.new(solr_data) }
end

shared_context "indexed from a site object", shared_context: :metadata do
	let(:types) { ['Publish Target'] }
	let(:slugs) { ['slug'] }
end

shared_context "indexed with restrictions", shared_context: :metadata do
	let(:restrictions) { ['Some Restriction'] }
end

shared_context "indexed with a doi", shared_context: :metadata do
	let(:dois) { ['doi:10.what/ever'] }
end

shared_context "indexed with a resolver source uri", shared_context: :metadata do
	let(:resolver_key) { 'rerecord' }
	let(:sources) { ["http://www.columbia.edu/cgi-bin/cul/resolve?#{resolver_key}"] }
end

shared_context "indexed with a url in-context" do
	let(:context_urls) { ['http://www.context.web/item'] }
end