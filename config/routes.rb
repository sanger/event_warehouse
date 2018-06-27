# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope path: '/api' do
    scope path: '/v1' do
      resources :event_types, only: %i[show index]
      resources :events, only: %i[show index]
      resources :subject_types, only: %i[show index]
      resources :subjects, only: %i[show index]
      resources :role_types, only: %i[show index]
      resources :roles, only: %i[show index]
    end
  end
end
