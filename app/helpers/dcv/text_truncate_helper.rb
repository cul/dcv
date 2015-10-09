module Dcv::TextTruncateHelper

  def truncate_text_to_250(args)
    
    truncation_length = 250
    
    field_value = args[:document][args[:field]]
    text_arr = field_value.is_a?(Array) ? field_value : [field_value]
    
    arr_to_return = []
    text_arr.each do |text|
      if text.length > truncation_length
        arr_to_return.push(text[0..truncation_length] + '...')
      else
        arr_to_return.push(text)
      end
    end
    
    return field_value.is_a?(Array) ? arr_to_return : arr_to_return[0]
  end

end