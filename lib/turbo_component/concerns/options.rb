module TurboComponent::Concerns::Options
  extend ActiveSupport::Concern

  included do
    include Shared

    helper_method :turbo_component_options
  end

  def turbo_component_options(*args)
    set_turbo_component_options(*args)

    opts = self.class.turbo_component_options
    class_default_opts = opts.fetch('default', {})
    class_action_opts = opts.fetch(action_name, {})

    instance_default_opts = @turbo_component_options.fetch('default', {})
    instance_action_opts = @turbo_component_options.fetch(action_name, {})

    result = {}.with_indifferent_access
               .deep_merge!(class_default_opts)
               .deep_merge!(class_action_opts)
               .deep_merge!(instance_default_opts)
               .deep_merge!(instance_action_opts)

    OpenStruct.new result
  end

  module Shared
    def set_turbo_component_options(*args)
      opts = args.extract_options!
      actions = args
      actions << 'default' if actions.blank?

      @turbo_component_options ||= {}.with_indifferent_access

      if opts.any?
        actions.each do |action|
          @turbo_component_options.deep_merge! action => opts
        end
      end
      @turbo_component_options
    end
  end

  module ClassMethods
    include Shared

    def turbo_component_options(*args)
      set_turbo_component_options(*args)

      if superclass && superclass.instance_variable_defined?(:@turbo_component_options)
        parent = superclass.instance_variable_get :@turbo_component_options
        parent.merge(@turbo_component_options)
      else
        @turbo_component_options
      end
    end
  end
end
