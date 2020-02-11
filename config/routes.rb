StartBootstrapAdminTheme::Engine.routes.draw do
  resources :pages, only: :show
end
