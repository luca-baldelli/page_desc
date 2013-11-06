module PageDesc
  module Actions
    module Element
      def text
        execute_with_hooks { browser_element.text }
      end

      def has_text? text
        execute_with_hooks { browser_element.has_text?(text) }
      end

      def css_class
        execute_with_hooks { browser_element[:class] }
      end

      def execute_with_hooks
        hooks[:before].call if hooks[:before]
        result = yield
        hooks[:after].call if hooks[:after]
        result
      end
    end
  end
end