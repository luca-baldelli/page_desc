module PageDesc
  class Element
    attr_reader :selector, :params
    attr_accessor :parent, :session


    def initialize options={}, &block
      @selector, @parent, @session = options[:selector], options[:parent], options[:session]
      @params = options[:params]
      self.extend ElementGenerator
      self.instance_exec(*@params, &block) if block_given?
    end

    [:before, :after].each do |hook|
      define_method(hook) do |action=nil, &block|
        if action
          (hooks[action]||={})[hook] = block
        else
          hooks[hook] = block
        end
      end
    end

    #TODO actions: set, values

    def browser_element
      return browser.document unless parent
      browser_element = parent.browser_element
      selector[:css] ? browser_element.find(@selector[:css]) : browser_element.find(:xpath, @selector[:xpath])
    end

    def browser
      @session || parent.session
    end

    private
    def hooks
      @hooks||={}
    end
  end
end