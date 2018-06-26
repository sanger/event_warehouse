# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope path: '/api' do
    scope path: '/v1' do
      resources :event_types, only: %i[show index]
    end
  end
end
