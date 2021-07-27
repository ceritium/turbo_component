# frozen_string_literal: true

module TurboComponent
  class Display
    class << self
      def render(params: {}, controller_class:, layout: nil, request: nil)
        display = controller_class::Display.new
        display.render(params: params, session: request.session)
        assigns = display.instance_variables.each_with_object({}) do |iv, ob|
          name = iv.to_s.delete("@")
          ob[name] = display.instance_variable_get(iv)
        end

        template_base_path = controller_class.name.split("::ComponentController", 2)[0].underscore
        controller_class.render(:display, assigns: assigns, template: "#{template_base_path}/views/display", layout: layout, locals: { session: request.session})
      end
    end
  end
end
