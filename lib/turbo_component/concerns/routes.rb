# frozen_string_literal: true

module TurboComponent::Concerns::Routes
  extend ActiveSupport::Concern

  included do
    @turbo_component_routes = []
  end

  module ClassMethods
    def display(action)
      controller_name = self.controller_name
      component_name = build_component_name
      turbo_component_routes do
        get component_name, to: "#{controller_name}##{action}", as: component_name
      end
    end

    def get(action, path = "")
      turbo_route(:get, action, path)
    end

    def post(action, path = "")
      turbo_route(:post, action, path)
    end

    def put(action, path = "")
      turbo_route(:put, action, path)
    end

    def patch(action, path = "")
      turbo_route(:patch, action, path)
    end

    def delete(action, path = "")
      turbo_route(:delete, action, path)
    end

    def turbo_route(verb, action, path)
      controller_name = self.controller_name
      component_name = build_component_name
      turbo_component_routes do
        send(verb, "#{component_name}/#{path}", to: "#{controller_name}##{action}", as: "#{component_name}_#{action}")
      end
    end

    def build_component_name
      self.name.split("::ComponentController", 2)[0].underscore
    end

    def turbo_component_routes(&block)
      @turbo_component_routes << block
    end

    def load_turbo_component_routes!(context)
      @turbo_component_routes.each do |proc|
        context.instance_eval(&proc)
      end
    end

    def inherited(subklass)
      subklass.instance_variable_set(:@turbo_component_routes, [])
      super
    end
  end
end
