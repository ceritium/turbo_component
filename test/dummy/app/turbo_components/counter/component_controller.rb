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
    Turbo::StreamsChannel.broadcast_replace_to "#{session.id}-counter", target: "counter", content: helpers.turbo_component(:counter, async: false)
    head :ok
  end
end
