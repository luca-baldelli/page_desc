
module PageDesc
  module Actions
    module ElementActions
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
    end
  end
end