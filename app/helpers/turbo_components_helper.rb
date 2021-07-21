# frozen_string_literal: true

module TurboComponentsHelper
  include Turbo::FramesHelper

  def turbo_component(turbo_key, opts = {}, &block)
    async = opts.delete(:async)

    if async
      turbo_component_async(turbo_key, opts, &block)
    else
      # TODO: raise exception, block not allowed
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
    base_params = params.to_unsafe_h.except(:action, :controller)
    url = polymorphic_url(turbo_url, base_params.merge(attrs))

    opts[:src] = url
    opts["data-turbo-permanent"] = true if permanent
    turbo_frame_tag(turbo_id, **opts, &block)
  end

  def turbo_component_inline_frame(turbo_key, opts)
    target = opts[:target]
    locals = opts[:locals] || {}
    turbo_id = opts[:turbo_id] || turbo_key
    turbo_frame_tag turbo_id, target: target do
      base_params = params.to_unsafe_h.except(:action, :controller)
      base_params[:_turbo_id] = turbo_id
      base_params = base_params.merge(locals)
      turbo_component_inline(turbo_key, locals: base_params)
    end
  end

  def turbo_component_inline(turbo_key, p_options = {})
    Rails.logger.info "Rendering turbo component #{turbo_key}"

    turbo_url = "turbo_component_#{turbo_key}"
    p_params = p_options.delete(:locals) { {} }.with_indifferent_access
    path = polymorphic_url(turbo_url, p_params)

    path_opts = Rails.application.routes.recognize_path(path)
    p_params.reverse_merge!(path_opts)

    controller_class = "#{path_opts[:controller].camelize}Controller".constantize
    action = path_opts[:action]

    c = controller_class.new
    c.turbo_component_options p_options
    c.turbo_component_options original_options: p_options

    env = controller.request.env.select do |key, _value|
      case key.to_s
      when /^action_dispatch\.request/i,
        /^action_controller/i,
        /^rack\.request/i,
        /^request/i,
        "HTTP_ACCEPT",
        "CONTENT_TYPE",
        "CONTENT_LENGTH",
        "REQUEST_METHOD"
        false
      else
        true
      end
    end

    # env['HTTP_X_REQUESTED_WITH'] = "XMLHttpRequest"
    env = Rack::MockRequest.env_for(path, env)
    p_request = ActionDispatch::Request.new(env)
    p_request.parameters.clear
    p_request.parameters.merge! p_params

    if c.method(:dispatch).arity == 3
      p_response = controller_class.make_response! p_request
      c.dispatch(action, p_request, p_response)
    else
      c.dispatch(action, p_request)
    end

    body = c.response.body
    body.html_safe
  end
end
