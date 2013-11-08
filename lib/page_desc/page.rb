module PageDesc
  class Page
    class << self
      attr_writer :main_element

      def url url=nil
        return @url unless url
        @url = url
      end

      def main_element
        @main_element ||= Element.new
      end

      def method_missing name, *args, &block
        main_element.send(name, *args, &block)
      end

      def inherited clazz
        clazz.main_element = @main_element
      end
    end

    attr_reader :url

    def initialize session
      @url = self.class.url
      @main_element = self.class.main_element.clone
      @main_element.session = session
    end

    def method_missing name, *args, &block
      @main_element.send(name, *args, &block)
    end
  end
end