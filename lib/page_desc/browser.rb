module PageDesc
  module Browser
    class << self
      attr_reader :mode

      def use mode
        @mode = mode
      end
    end

    def browser
      @session ||= PageDesc::Session.new(Browser.mode || :chrome)
    end

    def page
      browser.page
    end
  end
end