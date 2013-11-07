require_relative 'lib/page_desc'

class GooglePage < PageDesc::Page
  url 'http://google.co.uk'

  clickable :search, css: '#gbqfbb' do
    after do
      puts 'CALLED'
    end
  end
end

include PageDesc::Browser

browser.visit(GooglePage)

puts page.search.click