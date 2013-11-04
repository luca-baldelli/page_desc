require 'spec_helper'

describe PageDesc::Session do
  context 'initialization' do
    it 'should wrap a Capybara session' do
      session = Session.new(:chrome)
      session.instance_variable_get(:@capybara_session).should be_a(Capybara::Session)
    end

    it 'should create the browser driver' do
      Session.new(:chrome)
      driver = Capybara.drivers[:chrome].call

      driver.options[:browser].should == :chrome
    end
  end

  context 'Capybara session' do
    it 'should be be created with the mode provided by PageDesc::Session' do
      session = Session.new(:firefox)
      session.instance_variable_get(:@capybara_session).mode.should == :firefox
    end
  end

  describe 'navigation' do
    include_context :session

    let(:session) { Session.new(:chrome) }

    context 'move_to' do
      it 'should change the current page' do
        a_page = double(:a_page)
        a_page.should_receive(:new).with(session).and_return :page_instance
        session.move_to(a_page)
        session.page.should == :page_instance
      end
    end

    context 'visit' do
      it 'should visit the page and set current page' do
        page_instance = double(:page_instance, url: 'the url')
        page = double(:page, new: page_instance)

        session.capybara_session.should_receive(:visit).with('the url')
        session.visit(page)
        session.page.should == page_instance
      end
    end

    context 'document' do
      it 'should return the Capybara document' do
        session.document.should == session.capybara_session.document
      end
    end
  end
end