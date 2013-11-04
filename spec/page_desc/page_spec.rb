require 'spec_helper'

describe PageDesc::Page do
  before do
    class TestPage < Page
      url 'the url'
    end
  end

  it 'has a url' do
    TestPage.new(:session).url.should == 'the url'
  end

  it 'is sets the elements session' do
    TestPage.new(:session).instance_variable_get(:@main_element).instance_variable_get(:@session).should == :session
  end

  it 'delegates to main element' do
    test_page = TestPage.new(:session)
    test_page.instance_variable_get(:@main_element).should_receive(:some_method).with(:some_argument, :another_argument)
    test_page.some_method(:some_argument, :another_argument)
  end

  describe 'class' do
    context 'main element' do
      it 'has a main element' do
        TestPage.main_element.should be_a(Element)
      end

      it 'is lazily loaded' do
        TestPage.instance_variable_set(:@main_element, :the_document)
        TestPage.main_element.should == :the_document
      end

      it 'is passed to the instance' do
        document = Element.new
        TestPage.instance_variable_set(:@main_element, document)
        TestPage.new(:session).instance_variable_get(:@main_element).should == document
      end
    end

    it 'delegates to main element' do
      TestPage.main_element.should_receive(:some_method).with(:some_argument, :another_argument)
      TestPage.some_method(:some_argument, :another_argument) { @block_called = true }
    end
  end
end