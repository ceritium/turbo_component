class Counter::ComponentController < ApplicationController
  include TurboComponent::Concerns::Controller

  class Display
    def render(params:, **); end
  end

  post :increment, "increment"
  def increment
    session[:counter] ||= 0
    session[:counter] += 1

    render :display
  end
end
