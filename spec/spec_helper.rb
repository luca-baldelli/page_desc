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

  shared_context :element_actions do
    let(:element) do
      element = Element.new(session: double(:session, document: double(:document)))
      element.extend(Actions::Element)
      element
    end
  end
end