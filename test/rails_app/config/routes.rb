RailsApp::Application.routes.draw do
  resources :posts, only: :index

  get "/some-data",     to: "posts#some_data"
  get "/some-file",     to: "posts#some_file"
  get "/some-redirect", to: "posts#some_redirect"
  get "/some-boom",     to: "posts#some_boom"
end
