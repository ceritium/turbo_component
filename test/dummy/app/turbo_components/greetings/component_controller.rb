# frozen_string_literal: true

class Greetings::ComponentController < ApplicationController
  include TurboComponent::Concerns::Controller

  class Display
    def render(params:)
      @author = params[:author]
    end
  end
end
