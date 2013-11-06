module PageDesc
  module ElementGenerator
    [:element, :clickable].each do |element_type|
      define_method element_type do |*args, &block|
        identifier = args.first

        define_singleton_method identifier do |*params|
          if args[1].is_a?(Class)
            element = args[1].main_element.clone
            element.parent = self
          else
            element = Element.new(parent: self, selector: args[1], params: params, &block)
          end

          element.extend eval("Actions::#{element_type.to_s.capitalize}")
          element
        end
      end
    end
  end
end