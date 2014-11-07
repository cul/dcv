module Dcv::MapDataHelper

  def get_map_data_for_document_list(document_list)
    coordinate_output = []
    document_list.each do |document|
      if document['geo'].present?
        document['geo'].each do |coordinates|
          lat_and_long = coordinates.split(',')
          row = {
            lat: lat_and_long[0].strip, long: lat_and_long[1].strip, title: document['title_display_ssm'][0], popup_html: '<div>Cool <small style="color:blue;">html</small></div>',
            thumbnail_url: (document['image_filename_ssm'].blank? ? get_placeholder_thumbnail_url('book') : 'https://ldpd.cul.columbia.edu/durst-temp-images/thumbs/' + document['image_filename_ssm'][0].gsub(/\.[Tt][Ii][Ff][Ff]*/, '.jpg')),
            item_link: '/durst/' + document.id,
            #search_link: '/durst?utf8=✓&search_field=all_text_teim&q=&lat=' + lat_and_long[0] + '&long=' + lat_and_long[1]
          }
          coordinate_output << row
        end
      end
    end
    return coordinate_output
  end

end
