module PageDesc
  module BaseActions
    def text
      browser_element.text
    end

    def has_text? text
      browser_element.has_text?(text)
    end

    def css_class
      browser_element[:class]
    end
  end
end