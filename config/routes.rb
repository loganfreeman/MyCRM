# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
Rails.application.routes.draw do
  mount API => '/'
  resources :lists

  root to: 'home#index'

  get 'activities' => 'home#index'
  get 'resources' => 'resources#index'
  get 'suppliers' => 'suppliers#index'
  get 'admin'      => 'admin/users#index',       :as => :admin
  get 'login'      => 'authentications#new',     :as => :login
  delete 'logout'  => 'authentications#destroy', :as => :logout
  get 'profile'    => 'users#show',              :as => :profile
  get 'signup'     => 'users#new',               :as => :signup

  get '/home/options',  as: :options
  get '/home/toggle',   as: :toggle
  match '/home/timeline', as: :timeline, via: [:get, :put, :post]
  match '/home/timezone', as: :timezone, via: [:get, :put, :post]
  post '/home/redraw',   as: :redraw

  resource :authentication, except: [:index, :edit]
  resources :comments,       except: [:new, :show]
  resources :emails,         only: [:destroy]
  resources :passwords,      only: [:new, :create, :edit, :update]

  resources :accounts, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
    end
    member do
      put :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :contacts
      get :opportunities
    end
  end

  resources :itineraries, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
    end
    member do
      put :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :opportunities
      get :add_itinerary_item
    end
  end

  resources :itinerary_items, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
    end
    member do
      put :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :opportunities
      match :add_meal, via: [:get, :post]
      match :add_snack, via: [:get, :post]
      match :add_hotel_reservation, via: [:get, :post]
      match :add_transportation, via: [:get, :post]
      match :add_park_ticket, via: [:get, :post]
      match :add_guide_driver, via: [:get, :post]
    end
  end

  resources :meals, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
    end
    member do
      put :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :contacts
      get :opportunities
    end
  end

  resources :guide_drivers, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
    end
    member do
      put :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :contacts
      get :opportunities
    end
  end

  resources :park_tickets, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
      get :autocomplete_park_name
    end
    member do
      put :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :contacts
      get :opportunities
    end
  end

  resources :transportations, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
    end
    member do
      put :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :contacts
      get :opportunities
    end
  end

  resources :hotel_reservations, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
    end
    member do
      put :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :contacts
      get :opportunities
    end
  end

  resources :snacks, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
    end
    member do
      put :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :contacts
      get :opportunities
    end
  end

  resources :conferences, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
    end
    member do
      put :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :contacts
      get :opportunities
    end
  end

  resources :exibitions, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
    end
    member do
      put :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :contacts
      get :opportunities
    end
  end

  resources :hotels, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
    end
    member do
      put :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :contacts
      get :opportunities
    end
  end

  resources :restaurants, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
    end
    member do
      put :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :contacts
      get :opportunities
    end
  end

  resources :parks, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
    end
    member do
      put :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :contacts
      get :opportunities
    end
  end

  resources :transports, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
    end
    member do
      put :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :contacts
      get :opportunities
    end
  end

  resources :entertainments, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
    end
    member do
      put :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :contacts
      get :opportunities
    end
  end

  resources :campaigns, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
    end
    member do
      put :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :leads
      get :opportunities
    end
  end

  resources :contacts, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
      get :auto_complete_rails4
    end
    member do
      put :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :opportunities
    end
  end

  resources :leads, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
      get :autocomplete_account_name
    end
    member do
      get :convert
      post :discard
      post :subscribe
      post :unsubscribe
      put :attach
      match :promote, via: [:patch, :put]
      put :reject
    end
  end

  resources :opportunities, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
    end
    member do
      put :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :contacts
    end
  end

  resources :tasks, id: /\d+/ do
    collection do
      post :filter
      match :auto_complete, via: [:get, :post]
    end
    member do
      put :complete
      put :uncomplete
    end
  end

  resources :users, id: /\d+/, except: [:index, :destroy] do
    member do
      get :avatar
      get :password
      match :upload_avatar, via: [:put, :patch]
      patch :change_password
      post :redraw
    end
    collection do
      match :auto_complete, via: [:get, :post]
      get :opportunities_overview
    end
  end

  namespace :operator do
  end

  namespace :guide do
  end

  namespace :finance do
  end

  namespace :admin do
    resources :groups

    resources :customers do


    end

    resources :users do
      collection do
        match :auto_complete, via: [:get, :post]
      end
      member do
        get :confirm
        put :suspend
        put :reactivate
      end
    end

    resources :field_groups, except: [:index, :show] do
      collection do
        post :sort
      end
      member do
        get :confirm
      end
    end

    resources :fields do
      collection do
        match :auto_complete, via: [:get, :post]
        get :options
        get :redraw
        post :sort
        get :subform
      end
    end

    resources :tags, except: [:show] do
      member do
        get :confirm
      end
    end

    resources :fields, as: :custom_fields
    resources :fields, as: :core_fields

    resources :settings, only: :index
    resources :plugins,  only: :index
  end
end
