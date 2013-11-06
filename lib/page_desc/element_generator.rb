module PageDesc
  module ElementGenerator
    [Actions::Element, Actions::Clickable].each do |element_type|
      element_name = element_type.name[/.*::(.*)/, 1].downcase.to_sym

      define_method element_name do |*args, &block|
        identifier = args.first

        define_singleton_method identifier do |*params|
          if args[1].is_a?(Class)
            element = args[1].main_element.clone
            element.parent = self
          else
            element = Element.new(parent: self, selector: args[1], params: params, &block)
          end

          element.extend element_type
          element
        end
      end
    end
  end
end