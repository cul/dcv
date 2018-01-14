require 'rails_helper'

describe LcaajController, :type => :controller do
  before do
    @orig_config = SUBSITES['public']['lcaaj']
    SUBSITES['public']['lcaaj'] = {
      'layout' => 'lcaaj',
      'remote_request_api_key' =>'goodtoken',
      'map_search' => {
        'sidebar' => true,
        'default_lat' => 52.8,
        'default_long' => 21.5,
        'default_zoom' => 5
      }
    }
    expect(controller).not_to be_nil
    expect(controller.controller_name).not_to be_nil
  end
  after do
    SUBSITES['public']['lcaaj'] = @orig_config
  end
  describe '#index' do
    subject do
      get :index, params
      response
    end
    context 'respond to csv' do
      let(:doc1) { JSON.parse(fixture('controllers/lcaaj_controller/sample_solr_doc_1.json').read) }
      let(:doc2) { JSON.parse(fixture('controllers/lcaaj_controller/sample_solr_doc_2.json').read) }
      let(:doc3) { JSON.parse(fixture('controllers/lcaaj_controller/sample_solr_doc_3.json').read) }
      let(:params) {
        {
          format: 'csv',
          q: '',
          search_field: 'all_text_teim'
        }
      }
      let(:document_list) { [
        SolrDocument.new(doc1),
        SolrDocument.new(doc2),
        SolrDocument.new(doc3)
      ] }
      let(:expected_csv_data_as_2d_array) { CSV.parse(fixture('controllers/lcaaj_controller/csv_for_solr_docs.csv').read) }
      it "responds with expected csv data" do
        # skip access control related to cul_omniauth/roles.yml
        allow(controller).to receive(:store_unless_user).and_return nil
        allow(controller).to receive(:authorize_action).and_return true
        # mock get_search_results
        allow_any_instance_of(Blacklight::SolrHelper).to receive(:get_search_results).and_return(
          [{}, document_list],
          [{}, []]
        )
        expected_csv_data_as_2d_array.each do |expected_csv_row|
          expect(controller).to receive(:write_csv_line_to_response_stream).once.with(
            expected_csv_row
          ).ordered
        end
        get :index, params
        expect(response.status).to eq(200)
        expect(response.headers['Content-Type']).to eq("text/csv")
        expect(response.headers['Content-Disposition']).to eq('attachment; filename="search_results.csv"')
      end
    end
  end

  describe '#write_csv_line_to_response_stream' do
    let(:stream) {
      mock_stream = double("stream")
      allow(mock_stream).to receive(:write)
      mock_stream
    }
    let(:response) {
      mock_response = double("response")
      allow(mock_response).to receive(:stream).and_return(stream)
      mock_response
    }
    it "converts an csv line array to a CSV line string" do
      allow(controller).to receive(:response).and_return(response)
      expect(stream).to receive(:write).once.with("\"Comma field with words, words, and more words\",Second Field,Third Field\n")
      controller.send(:write_csv_line_to_response_stream, ["Comma field with words, words, and more words", "Second Field", "Third Field"])
    end
  end
end
