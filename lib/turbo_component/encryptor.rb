# frozen_string_literal: true

class TurboComponent::Encryptor
  def self.encode(data, purpose:)
    serialized = ActiveJob::Arguments.serialize(data)
    Rails.application.message_verifier(purpose).generate(serialized)
  end

  def self.decode(encrypted_data, purpose:)
    serialized = Rails.application.message_verifier(purpose).verify(encrypted_data)
    ActiveJob::Arguments.deserialize(serialized)
  end
end
