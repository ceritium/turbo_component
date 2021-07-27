# frozen_string_literal: true

module TurboComponent
  class Helpers
    include ActionDispatch::Routing::PolymorphicRoutes
    include ActionView::Helpers::UrlHelper

    include Rails.application.routes.url_helpers

    attr_reader :controller

    def initialize(controller)
      @controller = controller
    end

    def query_parameters
      controller.request.query_parameters
    end

    def turbo_url(turbo_key, turbo_id, locals)
      encoded = TurboComponent::Encryptor.encode(locals, purpose: turbo_id)
      attrs = { _encoded: encoded, _turbo_id: turbo_id }

      turbo_url = "turbo_component_#{turbo_key}"
      polymorphic_path(turbo_url, query_parameters.merge(attrs))
    end

    def component_inline(turbo_key, locals = {})
      Rails.logger.info "Rendering turbo component #{turbo_key}"

      turbo_url = "turbo_component_#{turbo_key}"
      url = polymorphic_url(turbo_url, locals)
      path_opts = Rails.application.routes.recognize_path(url)
      controller_class = "#{path_opts[:controller].camelize}Controller".constantize

      TurboComponent::Display.render(params: locals, controller_class: controller_class, request: controller.request)
    end
  end
end
