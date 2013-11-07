module PageDesc
  module Types
    module Clickable
      extend Action

      also_extend Element

      action :click do
        browser_element.click
      end
    end
  end
end