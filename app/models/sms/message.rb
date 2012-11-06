module Sms
  class Message < ActiveRecord::Base
    attr_accessible :content, :country_code, :gateway, :mobile_number, :status_code
  end
end
