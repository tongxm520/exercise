module ApplicationHelper
  def hidden_div_if(condition, attributes = {}, &block)
    if condition
      attributes["style"] = "display: none"
    end
    content_tag( "div", attributes, &block)
  end

  def paginate_meta_attributes(json, object)
    json.(object,
      :current_page,
      :next_page,
      :previous_page,
      :total_pages)
  end
end
