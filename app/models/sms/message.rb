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
      status_code == '0'
    end

    # Virtual attribute for success true/false
    def success
      is_successful?
    end

    # Returns true if sms has wrong number
    def has_wrong_number?
      status_code == '1'
    end

    protected

    def send_via_smsbao_gateway
      self.status_code = Sms::SmsbaoGateway.send_message(self.mobile_number, self.content)
    end

    def send_via_nexmo_gateway
      full_mobile_number = [country_code, mobile_number].join()
      self.status_code = Sms::NexmoGateway.send_message(full_mobile_number, self.content)
    end
  end
end
