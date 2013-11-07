require_relative 'lib/page_desc'

class GooglePage < PageDesc::Page
  url 'http://google.co.uk'

  clickable :lucky, css: '#gbqfbb' do
    after :click do
      puts 'CALLED'
    end
  end
end

include PageDesc::Browser

browser.visit(GooglePage)

puts page.lucky.click