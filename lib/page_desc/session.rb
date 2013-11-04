module PageDesc
  class Session
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
      @page = page.new self
    end
  end
end