module ApplicationHelper
  def hidden_dif_if(condition, attributes = {}, &block)
    if condition
      attributes['style'] = 'display: none;'
    else
      attributes.except!('style')
    end

    content_tag('div', attributes, &block)
  end
end
