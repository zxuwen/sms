Rails.application.routes.draw do

  mount Sms::Engine => "/sms"
end
