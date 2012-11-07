module Sms
  # Status codes are stored as follows:
  # If message is successful, put status code is 0
  # If number is wrong, status code is 1
  # Server error or other error: status code is 2, notifier will be sent to admin

  class Message < ActiveRecord::Base
    attr_accessible :content, :country_code, :gateway, :mobile_number, :status_code

    # Validations
    validates_presence_of :country_code, :mobile_number, :content

    # Sends the message via the appropriate gateway
    def deliver
      china_mobile? ? send_via_smsbao_gateway : send_via_nexmo_gateway
    end

    # Delivers sms if all parameters are fulfilled
    def deliver!
      deliver if valid?
      save # Returns true if save is successful, returns errors accessible through message.errors if false
    end

    # Checks if number is from China
    def china_mobile?
      country_code == 86
    end

    # Returns true if sms is successful
    def is_successful?
      status_code == 0
    end

    # Returns true if sms has wrong number
    def has_wrong_number?
      status_code == 1
    end

    protected

    # require 'open-uri'

    # TODO: Change to parameters that can be set in Env
    SMSBAO_USERNAME = "Hopcab"
    SMSBAO_PASSWORD = Digest::MD5.hexdigest("Wrsoq4j7lee")

    def send_via_smsbao_gateway
      Sms::SmsbaoGateway.set_account(SMSBAO_USERNAME, SMSBAO_PASSWORD)
      self.status_code = Sms::SmsbaoGateway.send_message(self.mobile_number, self.content)
      # content = CGI::escape(self.content)
      # url = "http://www.smsbao.com/sms?u=#{SMSBAO_USERNAME}&p=#{SMSBAO_PASSWORD}&m=#{self.mobile_number}&c=#{content}"

      # callback = open(url).read

      # case callback
      # when "0" # success -> return success (success true, message success)
      #   self.status_code = 0
      # when "-1" # passenger mobile error -> display error (success false, message failure)
      #   self.status_code = 1
      # else
      #   self.status_code = 2
      #   # TODO raise exception and send email to administrator
      # end
    end

    def send_via_nexmo_gateway
      puts 'nexmos'
    end
  end
end
