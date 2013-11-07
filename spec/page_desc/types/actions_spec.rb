require 'spec_helper'

describe PageDesc::Action do
  it 'can be extended to define custom elements' do
    module CustomElement
      extend PageDesc::Action

      action :test_action do |parameter|
        "test action called with parameter: '#{parameter}'"
      end
    end

    main_element = Element.new do
      custom_element :test_element
    end

    main_element.test_element.test_action('Value').should == "test action called with parameter: 'Value'"
  end
end