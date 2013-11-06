module PageDesc
  module Actions
    module Clickable
      def self.extended clazz
        clazz.extend Actions::Element
      end

      def click
        execute_with_hooks { browser_element.click }
      end
    end
  end
end