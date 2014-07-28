module Dcv::Catalog::ModsDisplayBehavior
  extend ActiveSupport::Concern

  def mods

    begin
      obj = ActiveFedora::Base.find(params[:pid])
      if obj.respond_to?(:descMetadata) && obj.descMetadata.present?
        xml_content = obj.descMetadata.content
        if params[:type] == 'formatted_text'
          xml_content = '<!DOCTYPE html><html><head><title>XML View</title></head><body style="border:1px solid #aaa;padding:0px 10px;">' + CodeRay.scan(xml_content, :xml).div() + '</body></html>'
          render text: xml_content
        elsif params[:type] == 'download'
          send_data(Nokogiri::XML(xml_content).to_xml, :type=>"text/xml",:filename => params[:pid].gsub(':', '_') + '.xml')
        else
          render xml: xml_content
        end
      else
        render text: 'No MODS record found for this object.'
      end
    rescue ActiveFedora::ObjectNotFoundError
      render text: 'Object not found.'
    end

  end

end
