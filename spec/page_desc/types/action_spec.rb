require 'spec_helper'

describe PageDesc::Action do
  before do
    module CustomElement
      extend PageDesc::Action

      action :test_action do |parameter|
        "test action called with parameter: '#{parameter}'"
      end

      action :another_action do
        'the action'
      end
    end
  end

  it 'can be extended to define custom elements' do
    main_element = Element.new do
      custom_element :test_element
    end

    main_element.test_element.test_action('Value').should == "test action called with parameter: 'Value'"
  end

  it 'calls hooks' do
    hooks_called = []
    main_element = Element.new do
      custom_element :test_element do
        before do
          hooks_called << 'before called'
        end

        after do
          hooks_called << 'after called'
        end
      end
    end

    main_element.test_element.test_action('Value')
    hooks_called.should == ['before called', 'after called']
  end

  it 'calls action specific hooks' do
    hooks_called = []
    main_element = Element.new do
      custom_element :test_element do
        before(:another_action) { hooks_called << 'before called on another_action' }
        before(:test_action) { hooks_called << 'before called on test_action' }
        before { hooks_called << 'before called' }

        after(:another_action) { hooks_called << 'after called on another_action' }
        after { hooks_called << 'after called' }
      end
    end

    main_element.test_element.another_action

    hooks_called.should == [
        'before called',
        'before called on another_action',
        'after called on another_action',
        'after called'
    ]
  end
end