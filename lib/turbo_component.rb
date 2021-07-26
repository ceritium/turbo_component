# frozen_string_literal: true

require "turbo-rails"
require "turbo_component/version"
require "turbo_component/engine"

module TurboComponent
  extend ActiveSupport::Autoload
  eager_autoload do
    autoload :Router
    autoload :Encryptor
    autoload :Helpers
    autoload :Display
  end

  module Concerns
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :Controller
      autoload :Options
      autoload :Routes
      autoload :Tags
    end
  end
end
