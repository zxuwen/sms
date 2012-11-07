require "sms/engine"
require 'open-uri'

module Sms
  class SmsbaoGateway

    # TODO: raise an error if account is not set
    def set_account(api_username, api_password)
      @username = api_username
      @password = Digest::MD5.hexdigest("#{api_password}")
    end

    # Send a message
    #
    # +options+ = {
    #   :mobile_number => "xxxx",
    #   :content => "some content"
    # }

    def send_message(mobile, content)
      content = CGI::escape(content)
      url = "http://www.smsbao.com/sms?u=#{@username}&p=#{@password}&m=#{mobile}&c=#{content}"

      callback = open(url).read

      case callback
      when "0" # success -> return success (success true, message success)
        status_code = 0
      when "-1" # passenger mobile error -> display error (success false, message failure)
        status_code = 1
      else
        status_code = 2
        # TODO raise exception and send email to administrator
      end

      return status_code
    end
  end
end
