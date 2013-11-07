
module PageDesc
  module Types
    module Element
      extend Action

      action :text do
        browser_element.text
      end

      action :has_text? do |text|
        browser_element.has_text?(text)
      end

      action :css_class do
        browser_element[:class]
      end

      action :attribute do |attribute|
        browser_element[attribute]
      end
    end
  end
end