# frozen_string_literal: true

module TurboComponent::Concerns::Controller
  extend ActiveSupport::Concern

  included do
    # order is important
    include TurboComponent::Concerns::Routes
    include TurboComponent::Concerns::Options

    include TurboComponentsHelper

    prepend_before_action :append_turbo_components_view_paths
    prepend_before_action :parse_locals

    append_view_path "app/turbo_components/"
    append_view_path "test/dummy/app/turbo_components/" if Rails.env.test?

    layout :layout_name

    helper_method :turbo_component_request?
    helper_method :turbo_key

    turbo_component_options layout: "container"
  end

  def layout_name
    layout = params[:layout] || turbo_component_options.layout

    "turbo_components/#{layout}"
  end

  def turbo_component_request?
    request.headers["Turbo-Frame"].present? && !turbo_stream_request?
  end

  def turbo_stream_request?
    request.headers.fetch("HTTP_ACCEPT", "")&.include?("text/vnd.turbo-stream")
  end

  def turbo_key
    params[:_turbo_id] || component_name
  end

  def component_name
    controller_path.split("/component", 2)[0]
  end

  private
  def parse_locals
    return unless params[:_encoded].present?

    decoded = TurboComponent::Encryptor.decode(params[:_encoded], purpose: params[:_turbo_id])
    decoded.each do |key, value|
      params[key] = value
    end
  end

  def append_turbo_components_view_paths
    # lookup_context.prefixes.clear
    view = "#{component_name}/views"
    lookup_context.prefixes.unshift view if lookup_context.prefixes.exclude?(view)

    # https://github.com/rails/actionpack-action_caching/issues/32
    lookup_context.formats.unshift :html if lookup_context.formats.exclude?(:html)
  end
end
