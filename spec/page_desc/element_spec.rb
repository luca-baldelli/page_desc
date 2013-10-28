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
    let(:browser) { double(:session, document: double(:document)) }

    before do
      Session.active = browser
    end

    it 'has a method for quick access to active session' do
      element = Element.new(parent: :parent, selector: {css: 'selector'})
      element.browser.should == browser
    end

    context 'browser element' do
      it 'returns the document if no selector specified' do
        element = Element.new
        element.browser_element.should == browser.document
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

    it 'delegates to browser element' do
      element = Element.new
      element.browser_element.should_receive(:some_method).with(:some_argument, :another_argument)
      element.some_method(:some_argument, :another_argument)
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
        element(:sub_element, css: 'some_css') do
          params = params()
        end
      end

      element.sub_element('a param', some: 'params')

      params.should == ['a param', {some: 'params'}]
    end

    context 'return object' do
      it 'can be configured' do
        element = Element.new do
          element(:sub_element, css: 'some_css') do
            return_object do |param|
              "custom return object: #{param}"
            end
          end
        end

        element.sub_element('The parameter').should == 'custom return object: The parameter'
      end
    end
  end

  context 'hooks' do
    it 'can be set in element block' do
      hooks_called = []

      element = Element.new do
        element(:sub_element, css: 'selector') do
          before { hooks_called << :before }
          after { hooks_called << :after }
        end
      end

      sub_element = double(:sub_element, click: 'click')
      element.stub(:browser_element).and_return(double(:parent_element, find: sub_element))
      element.sub_element.click
      hooks_called.should == [:before, :after]
    end

    it 'can be set in section' do

      class TheSection < Section
        selector(css: 'selector')

        before { (@hooks_called||=[]) << :before }
        after { (@hooks_called||=[]) << :after }
      end

      element = Element.new do
        element(:sub_element, TheSection)
      end

      sub_element = double(:sub_element, click: 'click')
      element.stub(:browser_element).and_return(double(:parent_element, find: sub_element))
      element.sub_element.click
      TheSection.instance_variable_get(:@hooks_called).should == [:before, :after]
    end
  end
end