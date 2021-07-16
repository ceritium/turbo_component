class TurboComponentGenerator < Rails::Generators::NamedBase
  desc 'Create a scaffold structure for a new turbo_component'
  source_root File.expand_path('templates', __dir__)

  def create_component_controller
    template 'component_controller.rb.tt', File.join(base_path, 'component_controller.rb')
  end

  def create_component_show_view
    @path = File.join(base_path, 'views/show.html.erb')
    @component_class_name = "#{name.classify}::Component"
    template 'show.html.erb.tt', @path
  end

  private

  def base_path
    File.join('app/turbo_components', name.underscore)
  end
end
