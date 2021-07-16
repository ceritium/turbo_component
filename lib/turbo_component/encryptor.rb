class TurboComponent::Encryptor
  DEFAULT_SALT = '!@#Q156^tdSXggT0&*789++8&?_|T%\/++==RqE'

  attr_reader :salt

  def self.encode(data, opts = {})
    purpose = opts.delete(:purpose)
    new(opts).encode(data, purpose: purpose)
  end

  def self.decode(encrypted_data, opts = {})
    purpose = opts.delete(:purpose)
    new(opts).decode(encrypted_data, purpose: purpose)
  end

  def self.get_key(secret, salt)
    @get_key_cache ||= {}
    key = [secret, salt]

    @get_key_cache[key] ||= ActiveSupport::KeyGenerator.new(secret).generate_key(salt)
  end

  def initialize(opts = {})
    @salt = opts.fetch :salt, DEFAULT_SALT
    @secret = opts[:secret]
  end

  def secret
    @secret || Rails.application.secrets[:secret_key_base]
  end

  def encode(data, purpose: nil)
    encryptor.encrypt_and_sign(data, purpose: purpose)
  end

  def decode(encrypted_data, purpose: nil)
    encryptor.decrypt_and_verify(encrypted_data, purpose: purpose)
  end

  private

  def encryptor
    @encryptor ||= begin
      key = self.class.get_key secret, salt
      key = key[0..31]
      ActiveSupport::MessageEncryptor.new(key)
    end
  end
end
