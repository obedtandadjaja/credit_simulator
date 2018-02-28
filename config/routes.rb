Rails.application.routes.draw do

  mount RootApi => '/'

  root 'home#index'

end
