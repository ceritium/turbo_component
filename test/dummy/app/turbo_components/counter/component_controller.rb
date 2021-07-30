# frozen_string_literal: true

class Counter::ComponentController < ApplicationController
  include TurboComponent::Concerns::Controller

  display :show
  def show
  end

  post :increment, "increment"
  def increment
    session[:counter] ||= 0
    session[:counter] += 1

    # Since this demo is based on the session, we should scope the broadcast by "session.id"
    turbo_stream_id = counter_turbo_stream_id
    Turbo::StreamsChannel.broadcast_replace_to turbo_stream_id, targets: "#counter", content: helpers.turbo_component(:counter, async: false)

    # We don't have to return nothing since we will update the component with Turbo::StreamChannel
    head :ok
  end
end
