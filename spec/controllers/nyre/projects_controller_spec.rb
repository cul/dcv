require 'rails_helper'

describe Nyre::ProjectsController, type: :controller do
  let(:controller) { described_class.new }
  let(:project) { FactoryBot.create(:nyre_project) }
  let(:params) {
    ActionController::Parameters.new(
      id: project.id
    )
  }
  let(:site) { FactoryBot.create(:site) }
  let(:request_double) { instance_double('ActionDispatch::Request') }
  before do
    @orig_config = SUBSITES['public']['nyre']
    SUBSITES['public']['nyre'] = {
      layout: 'nyre',
      map_search: {
        sidebar: true,
        default_lat: 40.757,
        default_long: -73.981,
        default_zoom: 11
      },
      remote_request_api_key:'goodtoken'
    }

    allow(request_double).to receive(:host).and_return('localhost')
    allow(request_double).to receive(:optional_port)
    allow(request_double).to receive(:protocol)
    allow(request_double).to receive(:path_parameters).and_return({})
    allow(request_double).to receive(:flash).and_return({})
    allow(controller).to receive(:params).and_return(params)
    allow(controller).to receive(:request).and_return(request_double)
    allow(controller).to receive(:load_subsite).and_return(site)
    allow(controller).to receive(:resource).and_return(OpenStruct.new(project.attributes))
    allow(controller).to receive(:search_results).and_return('facet_counts' => {})
  end
  after do
    SUBSITES['public']['nyre'] = @orig_config
  end
  describe '#show' do
    it 'renders' do
      controller.show
      expect(response).to have_http_status(200)
    end
    context "as RSS" do
      let(:params) do
        ActionController::Parameters.new(
          id: project.id,
          format: 'rss'
        )
      end
      before do
        allow(request_double).to receive(:variant)
      end
      it "returns not found" do
        expect(controller).to receive(:render).with(nothing: true, status: :not_found)
        controller.show
      end
    end
  end
end
