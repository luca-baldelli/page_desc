require 'spec_helper'

describe PageDesc::Element do

  context 'initialization' do
    it 'accepts a selector and a parent' do
      element = Element.new(parent: :parent, selector: {css: 'css-selector'})
      element.selector.should == {css: 'css-selector'}
      element.parent.should == :parent
    end

    it 'accepts a block' do
      element = Element.new do
        @parent = 'modified in block'
      end

      element.parent.should == 'modified in block'
    end
  end

  context 'active session' do
    it 'uses parents session' do
      parent = double(:parent, session: :browser)
      element = Element.new(parent: parent, selector: {css: 'selector'})
      element.browser.should == :browser
    end

    it 'uses its own session' do
      element = Element.new
      element.session = :browser
      element.browser.should == :browser
    end

    context 'browser element' do
      it 'returns the document if no selector specified' do
        element = Element.new(session: double(:browser, document: :document))
        element.browser_element.should == :document
      end

      it 'can be retrieved by css selector' do
        parent = double(:parent, browser_element: double(:browser_element))
        element = Element.new(parent: parent, selector: {css: 'selector'})
        browser_element = :browser_element

        parent.browser_element.should_receive(:find).with('selector').and_return browser_element
        element.browser_element.should == browser_element
      end

      it 'can be retrieved by xpath selector' do
        parent = double(:parent, browser_element: double(:browser_element))
        element = Element.new(parent: parent, selector: {xpath: 'selector'})
        browser_element = :browser_element

        parent.browser_element.should_receive(:find).with(:xpath, 'selector').and_return browser_element
        element.browser_element.should == browser_element
      end
    end
  end

  context 'sub elements' do
    let(:main_element) do
      Element.new do
        element :sub_element, css: 'some_css' do
          @block_executed = true
        end
      end
    end

    it 'can be created' do
      sub_element = main_element.sub_element

      sub_element.should be_a(Element)
      sub_element.selector.should == {css: 'some_css'}
      sub_element.parent.should == main_element
      sub_element.instance_variable_get(:@block_executed).should == true
    end

    it 'can be sections' do
      class SubSection < Section
      end

      section_main_element = Element.new(selector: {css: 'section'})
      SubSection.instance_variable_set(:@main_element, section_main_element)

      element = Element.new do
        element(:sub_section, SubSection)
      end

      sub_section = element.sub_section
      sub_section.selector.should == {css: 'section'}
      sub_section.parent.should == element
    end

    it 'can accept parameters' do
      params = nil

      element = Element.new do
        element(:sub_element, css: 'some_css') do |*args|
          params = args
        end
      end

      element.sub_element('a param', some: 'params')
      params.should == ['a param', {some: 'params'}]
    end

    describe 'actions' do
      context 'base actions' do
        it 'are extended by elements' do
          element = Element.new
          element.element :sub_element
          (class << element.sub_element; self; end).included_modules.should include(Types::Element)
        end

        it 'are extended by clickables' do
          element = Element.new
          element.clickable :sub_element, css: 'selector'
          (class << element.sub_element; self; end).included_modules.should include(Types::Element)
        end

        it 'are extended by sections' do
          class SubSection < Section
          end

          section_main_element = Element.new(selector: {css: 'section'})
          SubSection.instance_variable_set(:@main_element, section_main_element)

          element = Element.new do
            element(:sub_section, SubSection)
          end

          (class << element.sub_section; self; end).included_modules.should include(Types::Element)
        end
      end

      context 'clickable actions' do
        it 'are extended by clickables' do
          element = Element.new
          element.clickable :sub_element, css: 'selector'
          (class << element.sub_element; self; end).included_modules.should include(Types::Clickable)
        end
      end
    end
  end

  context 'hooks' do
    it 'can be set in element block' do
      element = Element.new do
        element(:sub_element, css: 'selector') do
          before { :before }
          after { :after }
        end
      end

      hooks = element.sub_element.instance_variable_get(:@hooks)
      hooks[:before].call.should == :before
      hooks[:after].call.should == :after
    end

    it 'can be set in section' do
      class TheSection < Section
        selector(css: 'selector')

        before { :before }
        after { :after }
      end

      element = Element.new do
        element(:sub_element, TheSection)
      end

      hooks = element.sub_element.instance_variable_get(:@hooks)
      hooks[:before].call.should == :before
      hooks[:after].call.should == :after
    end

    it 'can be action-specific' do
      element = Element.new do
        element(:sub_element, css: 'selector') do
          before(:click) { :before }
          after(:click) { :after }
        end
      end

      hooks = element.sub_element.instance_variable_get(:@hooks)
      hooks[:click][:before].call.should == :before
      hooks[:click][:after].call.should == :after
    end
  end
end