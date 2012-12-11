Mum::Application.routes.draw do
  devise_for :users

  resources :token_authentications, :only => [:create, :destroy]

  resources :dashboard

  resources :transactions

  resources :sclients

  constraints(:subdomain => /.+/) do
    # post "transactions/:user_id/transfer/:to_user_id/:fund/:currency" => "transactions#transfer", :constraints => { :fund => /\d+\.*\d{0,2}/, :user_id => /[0-9]{1,10}/, :to_user_id => /[0-9]{1,10}/ }
    post "transactions/:user_id/transfer" => "transactions#transfer", :constraints => { :fund => /\d+\.*\d{0,2}/, :user_id => /[0-9]{1,10}/, :to_user_id => /[0-9]{1,10}/ }
    post "transactions/:user_id/add/:fund/:currency" => "transactions#add", :constraints => { :fund => /\d+\.*\d{0,2}/, :user_id => /[0-9]{1,10}/ }
    post "transactions/:user_id/deduct/:fund/:currency" => "transactions#deduct", :constraints => { :fund => /\d+\.*\d{0,2}/, :user_id => /[0-9]{1,10}/ }

    # => Following line added by Saravana on 04-12-2012. Route gets all transactions for user id
    get "transactions/:user_id/account" => "transactions#summary", :constraints => { :user_id => /[0-9]{1,10}/ }
  end
end
