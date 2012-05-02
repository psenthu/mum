Mum::Application.routes.draw do
   # root :to => 'users#index'
  resources :users

  resources :dashboard

  constraints(:subdomain => /.+/) do
    match "transactions/:user_id/transfer/:to_user_id/:fund/:currency" => "transactions#transfer", :constraints => { :fund => /\d+\.*\d{0,2}/, :user_id => /[0-9]{1,10}/, :to_user_id => /[0-9]{1,10}/ }
    match "transactions/:user_id/add/:fund/:currency" => "transactions#add", :constraints => { :fund => /\d+\.*\d{0,2}/, :user_id => /[0-9]{1,10}/ }
    match "transactions/:user_id/deduct/:fund/:currency" => "transactions#deduct", :constraints => { :fund => /\d+\.*\d{0,2}/, :user_id => /[0-9]{1,10}/ }
  end
end
