require 'spec_helper'

describe Types::Element do
  include_context :types

  before do
    element.extend(Types::Element)
    element_with_hooks.extend(Types::Element)
  end

  describe 'text' do
    it 'can be read' do
      element.browser_element.should_receive(:text).and_return('text')
      element.text.should == 'text'
    end

    it 'can be read and hooks are called' do
      element_with_hooks.browser_element.should_receive(:text).and_return('text')
      element_with_hooks.text.should == 'text'
      hooks_called.should == [:before, :after]
    end
  end

  describe 'has_text?' do
    it 'can check if text is present' do
      element.browser_element.should_receive(:has_text?).with('text').and_return true
      element.has_text?('text').should == true
    end

    it 'can check if text is present and call hooks' do
      element_with_hooks.browser_element.should_receive(:has_text?).with('text').and_return true
      element_with_hooks.has_text?('text').should == true
      hooks_called.should == [:before, :after]
    end
  end

  describe 'css_class' do
    it 'can check if css class is present' do
      element.browser_element.should_receive(:[]).with(:class).and_return 'classes'
      element.css_class.should == 'classes'
    end

    it 'can check if css class is present and call hooks' do
      element_with_hooks.browser_element.should_receive(:[]).with(:class).and_return 'classes'
      element_with_hooks.css_class.should == 'classes'
      hooks_called.should == [:before, :after]
    end
  end

  describe 'attribute' do
    it 'can retrieve attribute value' do
      element.browser_element.should_receive(:[]).with(:href).and_return 'http://'
      element.attribute(:href).should == 'http://'
    end

    it 'can retrieve attribute value and call hooks' do
      element_with_hooks.browser_element.should_receive(:[]).with(:href).and_return 'http://'
      element_with_hooks.attribute(:href).should == 'http://'
      hooks_called.should == [:before, :after]
    end
  end
end