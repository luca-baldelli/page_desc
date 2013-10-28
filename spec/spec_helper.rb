$LOAD_PATH.unshift("#{__dir__}/../lib")

require 'simplecov' if ENV['coverage']
require 'page_desc'

RSpec.configure do
  include PageDesc

  shared_context :browser do
    include Browser
  end

  shared_context :session do
    class PageDesc::Session
      attr_reader :capybara_session
    end
  end
end