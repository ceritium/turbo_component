module Counter::Helpers
  include TurboComponent::Concerns::Exposable

  def self.turbo_stream_id(context)
    "#{context.session.id}-counter"
  end

  expose_in_context :turbo_stream_id
end
