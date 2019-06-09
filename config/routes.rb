Rails.application.routes.draw do

  	root to: 'urls#index'
  
  	get "shortened", to: "urls#shortened", as: :shortened
  	get "error", to: "urls#error", as: :error
  	get "top", to: "urls#top"
  	get "/:short_url", to: "urls#show"
  	post "/urls/create", to: "urls#create"

end
