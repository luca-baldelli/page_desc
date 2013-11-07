module PageDesc
  module Types
    module Clickable
      extend Action

      def self.extended clazz
        clazz.extend Types::Element
      end

      action :click do
        browser_element.click
      end
    end
  end
end