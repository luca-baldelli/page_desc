module PageDesc
  module Actions
    module ClickableActions
      extend Action

      def self.extended clazz
        clazz.extend Actions::ElementActions
      end

      action :click do
        browser_element.click
      end
    end
  end
end