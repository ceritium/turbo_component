# TurboComponent

This project explores the idea of components not only in terms of view, like [view_component](https://github.com/github/view_component) or [cells](https://github.com/trailblazer/cells), but it also includes server actions required for the component.

I part from the codebase of [pagelet_rails](https://github.com/antulik/pagelet_rails) and take advantage of turbo_rails to explore this idea.

## Usage

Please do not use it. It is a work in progress.

First of all, install [turbo-rails](https://github.com/hotwired/turbo-rails#installation).

Add `'turbo_component', '0.1.0.pre'` to the Gemfile.

Since this project is in an exploratory phase, you would like to use the master branch to get the last changes.

```
gem 'turbo_component`, git: 'https://github.com/ceritium/turbo_component.git`
```

Add `TurboComponent::Router.load_routes!(self)` to the `routes.rb`

Generate a turbo component:

```
 rails g turbo_component Sidebar
```

Use it somewhere:

```erb
<%= turbo_component :sidebar, permanent: true, async: true do %>
  loading...
<% end %>
```

## Inline routes

Because turbo_components are small you will have many of them. In order to keep them under control turbo_componets provides helpers.

You can define `post`, `put`, `patch` and `delete` inside your component controller as following:

```ruby
post :toggle_categories
def toggle_categories
  session[:show_categories] = !session[:show_categories]
  show
  render :show
end
```

## View helper

`turbo_component` accepts all the parameters of `turbo_frame_tag` plus some additional attributes:

- `async`: Allow render it inline or async (powered by turbo_frame). Default `false`.
- `turbo_id`: It is used as id on the turbo_frame_tag and for encoding the locals. Default `$turbo_component_key`, in the example is `sidebar`.
- `locals`: Like on `render partial:` you can pass attributes to the turbo component. In the case of loading it async, the locals are serialized and encrypted.

Example:

```ruby
<%= turbo_component :vote_author, async: true, locals: { author: @author } do %>
  loading...
<% end %>
```

## Demo

There is a rails demo app available: https://github.com/ceritium/turbo_component-demo

## TODO

- Add more demos and use cases.
- Improve testing.
- Consider view_component as default view system.
- Explore how to deal with [broadcast callbacks](https://github.com/hotwired/turbo-rails/blob/main/app/models/concerns/turbo/broadcastable.rb), I would like to define them inside the turbo component. 
- Improve gem setup.
- Refactor, most of this gem is C&P from pagelet and glue code.
