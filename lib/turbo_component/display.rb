# frozen_string_literal: true

module TurboComponent
  class Display
    class << self
      def render(params: {}, controller:, layout: nil)
        display = controller::Display.new
        display.render(params: params)
        assigns = display.instance_variables.each_with_object({}) do |iv, ob|
          name = iv.to_s.delete("@")
          ob[name] = display.instance_variable_get(iv)
        end

        template_base_path = controller.name.split("::ComponentController", 2)[0].underscore
        controller.render(:display, assigns: assigns, template: "#{template_base_path}/views/display", layout: layout)
      end
    end
  end
end
