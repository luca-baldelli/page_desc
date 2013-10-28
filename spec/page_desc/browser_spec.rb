require 'spec_helper'

describe PageDesc::Browser do
  context 'session' do
    let(:app) { Object.new }

    before do
      app.extend PageDesc::Browser
    end

    it 'should be a PageDesc session' do
      app.browser.should be_a(PageDesc::Session)
    end

    it 'is stored as a lazily initialized attribute' do
      app.browser.should == app.browser
    end

    describe 'browser' do
      before :each do
        Browser.instance_variable_set(:@mode, nil)
      end

      it 'is defaulted to Chrome' do
        Session.should_receive(:new).with(:chrome)
        app.browser
      end

      it 'can be configured' do
        Browser.use :firefox

        Session.should_receive(:new).with(:firefox)
        app.browser
      end
    end

    describe 'page' do
      it 'should return the current page set in the browser' do
        session = double(:session, page: :the_page)
        Session.stub(:new).and_return(session)
        app.page.should == app.browser.page
      end
    end
  end
end