module TurboComponent::Concerns::Exposable
  extend ActiveSupport::Concern

  included do
    def self.expose_in_context(method_name)
      prefix = self.name.deconstantize.underscore
      module_ref = self
      exposed_name = "#{prefix}_#{method_name}".to_sym

      ApplicationController.class_eval do
        define_method exposed_name do
          module_ref.send(method_name, self)
        end

        helper_method exposed_name
      end

      exposed_name
    end
  end
end
