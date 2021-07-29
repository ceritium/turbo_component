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

    render :show
  end
end
