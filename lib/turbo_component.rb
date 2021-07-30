# frozen_string_literal: true

require "turbo-rails"
require "turbo_component/version"
require "turbo_component/engine"
require "turbo_component/railtie"

module TurboComponent
  extend ActiveSupport::Autoload
  eager_autoload do
    autoload :Router
    autoload :Encryptor
  end

  module Concerns
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :Controller
      autoload :Options
      autoload :Routes
      autoload :Tags
      autoload :Exposable
    end
  end
end
