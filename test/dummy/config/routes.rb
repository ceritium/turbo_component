Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  TurboComponent::Router.load_routes!(self)
  # scope :foo, as: nil do
  #   TurboComponent::Router.load_routes!(self)
  # end

  root 'welcome#show'
end
