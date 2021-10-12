Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #customer側devise
  devise_for :customers, controllers: {
    sessions: 'customers/sessions',
    passwords: 'customers/passwords',
    registrations: 'customers/registrations'
  }

  # Top画面
  root 'customers/items#top'
  get 'items' => 'customers/items#about'

  # customer側のルーティング設定
  namespace :customers do
    get '/search' => 'search#search'

    resources :items, only: [:index, :show]

    resources :cart_items, only: [:index, :update, :create, :destroy] do
      collection do
        delete 'all_destroy'
      end
    end

    # get=データを取得する処理、patch=情報を更新する(SQLでいうupdate)
    resources :customers,only: [:show, :edit, :update] do
      collection do
        get 'quit'
        patch 'out'
      end
    end
    # collection=　resourcesでは自動生成されないものに使う。生成するroutingに:idがつかない。


    resources :orders,only: [:new,:index,:show,:create] do
      collection do
        post 'to_log'
        get 'thanx'
      end
    end
    # post=URLが保存可、get=URL保存不可

    resources :addresses,only: [:index,:create,:destroy,:edit,:update]
  end

end
