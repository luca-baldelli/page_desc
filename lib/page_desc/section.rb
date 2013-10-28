module PageDesc
  class Section
    class << self
      attr_reader :main_element

      def selector selector
        @main_element = Element.new(selector: selector)
      end

      def method_missing name, *args, &block
        main_element.send(name, *args, &block)
      end
    end
  end
end