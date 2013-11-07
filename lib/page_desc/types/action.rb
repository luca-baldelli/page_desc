module PageDesc
  module Action
    class << self
      def types
        @types||=[]
      end

      def extended clazz
        clazz.instance_eval { include InstanceMethods }
        types << clazz
      end
    end

    def action name, &block
      define_method name do |*args|
        execute_with_hooks(name) { instance_exec(*args, &block) }
      end
    end

    module InstanceMethods
      def execute_with_hooks(name)
        hooks[:before].call if hooks[:before]
        hooks[name][:before].call if hooks[name] && hooks[name][:before]
        result = yield
        hooks[name][:after].call if hooks[name] && hooks[name][:after]
        hooks[:after].call if hooks[:after]
        result
      end
    end
  end
end