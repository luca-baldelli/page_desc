require 'spec_helper'

describe Actions::Clickable do
  include_context :actions

  before do
    element.extend(Actions::Clickable)
    element_with_hooks.extend(Actions::Clickable)
  end

  describe 'click' do
    it 'can click the browser element' do
      element.browser_element.should_receive(:click)
      element.click
    end

    it 'can click the browser element and call hooks' do
      element_with_hooks.browser_element.should_receive(:click)
      element_with_hooks.click
      hooks_called.should == [:before, :after]
    end
  end
end