module PageDesc
  class Page
    class << self
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
    end

    attr_reader :url

    def initialize
      @url = self.class.url
    end

    def method_missing name, *args, &block
      self.class.main_element.send(name, *args, &block)
    end
  end
end