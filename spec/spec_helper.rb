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

  shared_context :types do
    let(:element) do
      Element.new(session: double(:session, document: double(:document)))
    end

    let(:element_with_hooks) do
      Element.new(session: double(:session, document: double(:document))) do
        before { (@hooks_called||=[]) << :before }
        after { (@hooks_called||=[]) << :after }
      end
    end

    let(:hooks_called) { element_with_hooks.instance_variable_get(:@hooks_called) }
  end
end