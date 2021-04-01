require 'rails_helper'
describe Iiif::Manifest do
	let(:fedora_pid) { 'test:c_agg' }
	let(:foxml) { fixture("foxml/#{fedora_pid.sub(':','_')}.xml").read }
	let(:rubydora_repository) do
		Rubydora::Repository.new({}, SingleObjectFcrApi.new(foxml))
	end
	let(:rubydora_object) { ActiveFedora::DigitalObject.new(fedora_pid, rubydora_repository) }
	let(:active_fedora_object) do
		::ActiveFedora::Base.allocate.init_with_object(rubydora_object)
	end
	let(:representative_resource) do
		gr_pid = 'test:gr'
		gr_foxml = fixture("foxml/#{gr_pid.sub(':','_')}.xml").read
		gr_repo = Rubydora::Repository.new({}, SingleObjectFcrApi.new(gr_foxml))
		gr_obj = ActiveFedora::DigitalObject.new(gr_pid, gr_repo)
		::ActiveFedora::Base.allocate.init_with_object(gr_obj)
	end
	let(:solr_adapter) { Dcv::Solr::DocumentAdapter::ActiveFedora.new(active_fedora_object) }
	let(:manifest_document) { SolrDocument.new(solr_adapter.to_solr) }
	let(:route_helper) do
		TestRouteHelper.new
	end
	let(:children_service) { instance_double(Dcv::Solr::ChildrenAdapter) }
	let(:manifest_id) do
		registrant, doi = manifest_document.doi_identifier.split('/')
		route_helper.iiif_manifest_url(manifest_registrant: registrant, manifest_doi: doi)
	end
	let(:iiif_manifest) { described_class.new(manifest_id, manifest_document, children_service, route_helper) }
	before do
		allow(solr_adapter).to receive(:get_representative_generic_resource).and_return(representative_resource)
	end
	describe '#label' do
		let(:actual) { iiif_manifest.label }
		it "sets an array of values" do
			expect(actual[:en]).to be_a Array
			expect(actual[:en]).to include "With William Burroughs: a report from the bunker: Burroughs comes across a variety of the yage vine in the jungle..., p. 113, image"
		end
	end
	describe '#items' do
		it 'delegates to children_service for structured list' do
			expect(children_service).to receive(:from_all_structure_proxies).and_return([])
			iiif_manifest.items
		end
	end
	describe '#as_json' do
		context "without :include values" do
			it "does not include #metadata, #items, or context" do
				expect(iiif_manifest).not_to receive(:items)
				expect(iiif_manifest).not_to receive(:metadata)
				actual = iiif_manifest.as_json
				expect(actual['@context']).to be_blank
				expect(actual['items']).to be_blank
				expect(actual['metadata']).to be_blank
			end
		end
	end
end