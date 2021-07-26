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

  def turbo_helpers
    @turbo_helpers ||= TurboComponent::Helpers.new(controller)
  end

  def turbo_component_async(turbo_key, opts = {}, &block)
    turbo_id = opts.delete(:turbo_id) || turbo_key
    locals = opts.delete(:locals) || {}
    permanent = opts.delete(:permanent)

    opts[:src] = turbo_helpers.turbo_url(turbo_key, turbo_id, locals)
    opts["data-turbo-permanent"] = true if permanent
    turbo_frame_tag(turbo_id, **opts, &block)
  end

  def turbo_component_inline_frame(turbo_key, opts)
    target = opts[:target]
    locals = opts[:locals] || {}
    turbo_id = opts[:turbo_id] || turbo_key
    turbo_frame_tag turbo_id, target: target do
      query_params = controller.request.query_parameters.deep_dup
      query_params[:_turbo_id] = turbo_id
      query_params = query_params.merge(locals)
      turbo_helpers.component_inline(turbo_key, query_params)
    end
  end
end
