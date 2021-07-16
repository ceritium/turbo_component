class Greetings::ComponentController < ApplicationController
  include TurboComponent::Concerns::Controller

  display :show
  def show
    @author = params[:author]
  end

  post :bye, "bye/:name"
  def bye
    # TODO
  end
end
