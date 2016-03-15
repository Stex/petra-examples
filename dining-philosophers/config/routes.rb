Rails.application.routes.draw do
  root 'philosophers#index'

  resources :philosophers do
    collection do
      post :leave
    end
  end

  resource :philosopher, :only => :show do
    member do
      post :think
    end
  end

  resources :sticks do
    collection do
      post :take_left
      post :take_right
      post :put_left
      post :put_right
      post :commit
    end
  end
end
