# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope path: '/api' do
    scope path: '/v1' do
      resources :event_types
      resources :events
      resources :subject_types
      resources :subjects
      resources :role_types
      resources :roles
    end
  end
end
