class WelcomeController < ApplicationController
  def show
    @author = Author.last
  end
end
