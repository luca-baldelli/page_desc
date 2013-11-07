require_relative 'lib/page_desc'

module Button
  extend PageDesc::Action

  also_extend PageDesc::Types::Clickable

  action :on_click do
    puts browser_element[:onclick]
  end
end

class More < PageDesc::Section
  selector css: '#more-less-button'

  before :on_click do
    puts 'before CALLED'
  end

  after :on_click do
    puts 'after CALLED'
  end
end

class GooglePage < PageDesc::Page
  url 'http://google.co.uk'

  button :more, More
end

include PageDesc::Browser

browser.visit(GooglePage)

page.more.on_click
page.more.click