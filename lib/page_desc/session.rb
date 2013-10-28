module PageDesc
  class Session
    class << self
      attr_accessor :active
    end

    attr_reader :page

    def initialize mode
      Capybara.register_driver mode do |app|
        Capybara::Selenium::Driver.new(app, browser: mode)
      end

      @capybara_session = Capybara::Session.new(mode)
    end

    def visit page
      move_to(page)
      @capybara_session.visit(@page.url)
    end

    def document
      @capybara_session.document
    end

    def move_to page
      Session.active = self
      @page = page.new
    end
  end
end