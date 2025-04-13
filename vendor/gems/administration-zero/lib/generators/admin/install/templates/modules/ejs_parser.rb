class EJSParser
  # EJSParser::build_html_from_ejs_content(content: @post.content, classes: { header: "foo", paragraph: "bar" })
  # Classes are optional, method applies @default_classes if none are passed as an arg.
  # "Otherwise, the classes passed as an argument will be used for the specified elements. For example, 
  # classes: { header: "foo" } will apply the 'foo' class to the 'header' element, while the remaining elements will 
  # still use the classes defined in @default_classes."

  def self.build_html_from_ejs_content(**args)
    begin
      content_blocks = JSON.parse(args[:content])["blocks"]
    rescue
      return "Unable to show content."
    end

    @classes = args[:classes] || {}

    html_content = ""

    content_blocks.each do |block|
      type = block["type"]
      data = block["data"]

      @classes[type.to_sym].nil? ? @css_classes = @default_classes[type.to_sym] : @css_classes = @classes[type.to_sym]

      begin
        parsed_data = eval("parse_#{type}_block(#{data}, \"#{@css_classes}\")")
      rescue
        parsed_data = ""
      end

      html_content += parsed_data
    end

    html_content.html_safe
  end

  # EJSParser::summary_for_ejs_content(content: @post.content, truncate: 500)
  # Truncate is optional.
  def self.summary_for_ejs_content(**args)
    begin
      first_paragraph = JSON.parse(args[:content])["blocks"].find {|block| block["type"] == "paragraph"}
      brief = first_paragraph["data"]["text"]
      truncate = args[:truncate]
      truncate.nil? ? brief : brief.truncate(truncate)
    rescue
      return "Unable to show content."
    end
  end
  
  # E.g.: { "text"=>"Header", "level"=>2 }
  def self.parse_header_block(*args)
    data = args[0]
    text, level = data["text"], data["level"]
    # For Bulma CSS.
    classes = "is-size-#{level} " + args[1] || "is-size-#{level}"

    "<h#{level} class=\"#{classes}\">#{text}</h#{level}>"
  end

  def self.parse_paragraph_block(*args)
    text = args[0]["text"]
    classes = args[1]
    "<p class = \"#{classes}\">" + text + "</p>"
  end

  def self.parse_image_block(*args)
    data, classes = args[0], args[1]
    caption, url  = data["caption"], data["file"]["url"]

    # The following image parameters from EditorJS are currently ignored:
    # bordered, stretched, with_background = data["withBorder"], data["stretched"], data["withBackground"]

    "<figure class=\"image #{classes}\">" + "<img src=#{url} loading=\"lazy\">" + "</figure>"
  end

  def self.parse_quote_block(*args)
    data, classes = args[0], args[1]
    text, caption, alignment = data["text"], data["caption"], data["alignment"]
    classes += " has-text-centered" if alignment == "center" # Bulma CSS

    "<blockquote class=\"#{classes}\">" + text +
    "<p class=\"is-size-7 is-italic pt-3 has-text-grey\">&mdash; #{caption}</p>" +
    "</blockquote>"
  end

  def self.parse_list_block(*args)
    data, classes = args[0], args[1]
    list_items = data["items"]
    list_items.map! { "<li>" + it["content"] + "</li>" }
    list_content = "" ; list_items.each { list_content += it }

    if data["style"] == "ordered"
      "<ol class=\"#{classes}\">" + list_content + "</ol>"
    else
      "<ul class=\"#{classes}\">" + list_content + "</ul>"
    end
  end

  def self.parse_delimiter_block(*args)
    classes = args[1]
    "<hr class=\"#{classes}\">"
  end

  def self.parse_code_block(*args)
    data, classes = args[0], args[1]
    escaped_code = CGI.escapeHTML(data["code"])
    "<pre><code class=\"#{classes}\">#{escaped_code}</code></pre>"
  end

  @default_classes = {
    header: "",
    paragraph: "",
    image: "",
    quote: "",
    list: "",
    delimiter: "",
    code: ""
  }
end
