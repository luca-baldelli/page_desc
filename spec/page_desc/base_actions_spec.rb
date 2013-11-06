require 'spec_helper'

describe Actions::Element do
  include_context :element_actions

  it 'can read browser element text' do
    element.browser_element.should_receive(:text).and_return('text')
    element.text.should == 'text'
  end

  it 'can check if text is present' do
    element.browser_element.should_receive(:has_text?).with('text').and_return true
    element.has_text?('text').should == true
  end

  it 'can check if css class is present' do
    element.browser_element.should_receive(:[]).with(:class).and_return 'classes'
    element.css_class.should == 'classes'
  end
end