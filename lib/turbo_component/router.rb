# frozen_string_literal: true

module TurboComponent
  class Router
    def self.load_routes!(context)
      controllers = Dir[Rails.root.join("app", "turbo_components", "**", "*controller.rb")]

      controllers.each do |controller_file|
        module_name = module_name(controller_file)
        controller = "#{module_name.camelize}::ComponentController".constantize

        next unless controller.respond_to? :load_turbo_component_routes!

        context.instance_eval do
          scope module: module_name, path: "/_turbo_components", as: "turbo_component" do
            controller.load_turbo_component_routes! self
          end
        end
      end
    end

    def self.module_name(file)
      File.dirname(file)
          .split(Rails.root.join("app/turbo_components/").to_s, 2)[-1]
    end
  end
end
