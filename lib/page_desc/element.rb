module PageDesc
  class Element
    attr_reader :selector, :hook, :params
    attr_accessor :parent, :session

    def initialize options={}, &block
      @selector, @parent, @session = options[:selector], options[:parent], options[:session]
      @params = options[:params]
      self.instance_eval(&block) if block_given?
    end

    def element *args, &block
      identifier = args.first

      define_singleton_method identifier do |*params|
        if args[1].is_a?(Class)
          element = args[1].main_element.clone
          element.parent = self
          element
        else
          Element.new(parent: self, selector: args[1], params: params, &block)
        end
      end
    end

    [:before, :after].each do |hook|
      define_method(hook) do |&block|
        hooks[hook] = block
      end
    end

    def method_missing name, *args
      hooks[:before].call if hooks[:before]
      browser_element.send(name, *args)
      hooks[:after].call if hooks[:after]
    end

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