module PageDesc
  module Action
    def self.extended clazz
      clazz.instance_eval { include InstanceMethods }
    end

    def action name, &block
      define_method name do |*args|
        execute_with_hooks { instance_exec(*args, &block) }
      end
    end

    module InstanceMethods
      def execute_with_hooks
        hooks[:before].call if hooks[:before]
        result = yield
        hooks[:after].call if hooks[:after]
        result
      end
    end
  end
end