# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # TODO: The gem should handle it
  append_view_path "app/turbo_components/"
  append_view_path "test/dummy/app/turbo_components/"
end
