require "sms/engine"
require 'open-uri'
require 'nexmo'

module Sms
  # For sending of China numbers
  class SmsbaoGateway

    class << self
      # TODO: raise an error if account is not set
      def set_account(api_username, api_password)
        @username = api_username
        @password = Digest::MD5.hexdigest("#{api_password}")
      end

      def send_message(mobile, content)
        content = CGI::escape(content)
        url = "http://www.smsbao.com/sms?u=#{@username}&p=#{@password}&m=#{mobile}&c=#{content}"
        callback = open(url).read
        case callback
        when "0" # success -> return success (success true, message success)
          status_code = '0'
        when "-1" # passenger mobile error -> display error (success false, message failure)
          status_code = '1'
        else
          status_code = "SmsbaoGateway Error: #{callback}"
          # TODO: Send email to administrator
        end
        return status_code
      end
    end
  end

  # Using Nexmo for sending of other international numbers
  class NexmoGateway

    class << self
      def set_account(api_key, api_secret, sender)
        @nexmo = Nexmo::Client.new(api_key, api_secret)
        @sender = sender
      end

      def send_message(mobile, content)

        response = @nexmo.send_message({
          from: "#{@sender}",
          to: "#{mobile}",
          text: "#{content}"
        })

        if response.success?
          status_code = '0'
        elsif response.failure?
          error_code = response.error.split('=').last # Find the cause of error
          case error_code # When wrong number
          when '3'
            status_code = '1'
          else
            status_code = "NexmoGateway Error: #{response.error}"
          end
        end
          return status_code
      end
    end
  end
end
