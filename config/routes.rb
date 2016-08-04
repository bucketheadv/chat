Rails.application.routes.draw do

  root to: 'home#index'

  devise_for :users

  get '/my/contacts' => 'my#contacts', as: :my_contacts
  get '/my/message_board' => 'my#message_board', as: :my_message_board
  delete '/conversations/delete_my_conversation/:id' => 'conversations#delete_my_conversation', as: :delete_my_conversation

  get '/home/users' => 'home#users', as: :all_users
  resources :conversations, only: [:new, :show] do
    resources :messages, only: [:create, :destroy]
  end

  resources :friends, only: [:update, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
