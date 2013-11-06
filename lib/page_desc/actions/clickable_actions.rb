module PageDesc
  module Actions
    module Clickable
      def self.extended clazz
        clazz.extend Actions::Element
      end
    end
  end
end