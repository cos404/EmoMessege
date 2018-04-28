Rails.application.routes.draw do

  post  'registerMessage' => 'message#create'
  get   'recipientStats' => 'recipient#show'

end
