# frozen_string_literal: true

class WelcomeController < ApplicationController
  def show
    @author = Author.last
  end
end
