KboApi::Application.routes.draw do

  match 'comments(.format)' => "comments#create", :via => :post
  match 'comments/:id(.format)' => "comments#show", :via => :get, :constraints => {:id => /\d+/}
  match 'get_comments(.format)' => "comments#getComments", :via => :get
  match 'get_more_comments(.format)' => "comments#getMoreComments", :via => :get

  match 'users(.format)' => "users#create", :via => :post
  match 'users(.format)' => "users#destroy", :via => :delete
  match 'users/get_userinfo(.format)' => "users#getUserInfo", :via => :get 
  match 'users/get_nickname_uniqueness(.format)' => "users#checkUniqueness", :via => :get 
  match 'users/block(.format)' => "users#blockUser", :via => :post  
  match 'users/unblock(.format)' => "users#unBlockUser", :via => :post  
  match 'users/blocked_list(.format)' => "users#getBlockedUserList", :via => :get  
  match 'users/alert(.format)' => "users#alertUser", :via => :post  
  match 'users/high_alert_users(.format)' => "users#getHighAlertUsers", :vis => :get

  match 'update(.json)' => "updates#create", :via => :post
  match 'update/get_last_update(.json)' => "updates#getLastUpdate", :via => :get
end
