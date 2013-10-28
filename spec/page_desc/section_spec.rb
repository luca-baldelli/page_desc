require 'spec_helper'

describe PageDesc::Section do
  it 'has a main element' do
    Section.instance_variable_set(:@main_element, :main_element)
    Section.main_element.should == :main_element
  end

  describe 'main element' do
    it 'is identified by a selector' do
      class TestSection < Section
        selector css: 'selector'
      end

      TestSection.main_element.should be_a(Element)
      TestSection.main_element.selector.should == {css: 'selector'}
    end
  end

  describe 'class' do
    before do
      class TestSection < Section
        selector css: 'selector'
      end
    end

    it 'delegates to main element' do
      TestSection.main_element.should_receive(:some_method).with(:some_argument, :another_argument)
      TestSection.some_method(:some_argument, :another_argument) { @block_called = true }
    end
  end
end