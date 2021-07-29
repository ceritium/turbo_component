# frozen_string_literal: true

module TurboComponentsHelper
  include Turbo::FramesHelper

  def turbo_component(turbo_key, opts = {}, &block)
    async = opts.delete(:async)

    if async
      turbo_component_async(turbo_key, opts, &block)
    else
      turbo_component_inline_frame(turbo_key, opts)
    end
  end

  def turbo_component_async(turbo_key, opts = {}, &block)
    turbo_id = opts.delete(:turbo_id) || turbo_key
    locals = opts.delete(:locals) || {}
    permanent = opts.delete(:permanent)

    # TODO: cache
    encoded = TurboComponent::Encryptor.encode(locals, purpose: turbo_id)
    attrs = { _encoded: encoded, _turbo_id: turbo_id }

    turbo_url = "turbo_component_#{turbo_key}"
    query_parameters = controller.request.query_parameters
    url = polymorphic_url(turbo_url, query_parameters.merge(attrs))

    opts[:src] = url
    opts["data-turbo-permanent"] = true if permanent
    turbo_frame_tag(turbo_id, **opts, &block)
  end

  def turbo_component_inline_frame(turbo_key, opts)
    target = opts[:target]
    locals = opts[:locals] || {}
    turbo_id = opts[:turbo_id] || turbo_key
    turbo_frame_tag turbo_id, target: target do
      query_parameters = controller.request.query_parameters
      query_parameters[:_turbo_id] = turbo_id
      query_parameters = query_parameters.merge(locals)
      turbo_component_inline(turbo_key, query_parameters)
    end
  end

  def turbo_component_inline(turbo_key, locals)
    Rails.logger.info "Rendering turbo component #{turbo_key}"

    turbo_url = "turbo_component_#{turbo_key}"
    path = polymorphic_url(turbo_url, locals)

    path_opts = Rails.application.routes.recognize_path(path)
    controller_class = "#{path_opts[:controller].camelize}Controller".constantize
    action = path_opts[:action]

    c = controller_class.new
    p_request = ActionDispatch::Request.new(controller.request.env)
    p_request.headers["Turbo-Component-Inline"] = true
    p_request.parameters.clear
    p_request.parameters.merge!(locals)

    p_response = controller_class.make_response!(p_request)
    c.dispatch(action, p_request, p_response)
    c.response.body.html_safe
  end
end
