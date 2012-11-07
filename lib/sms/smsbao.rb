module Sms
  module Smsbao
      require 'open-uri'

      # TODO: Env parameters
      SMSBAO_USERNAME = "Hopcab"
      SMSBAO_PASSWORD = Digest::MD5.hexdigest("Wrsoq4j7lee")

      def send_via_smsbao_gateway
        content = CGI::escape(self.content)
        url = "http://www.smsbao.com/sms?u=#{SMSBAO_USERNAME}&p=#{SMSBAO_PASSWORD}&m=#{self.mobile}&c=#{content}"

        callback = open(url).read

        case callback
          when "0" # success -> return success (success true, message success)
            set_success_status(true, "success")
          when "-1" # passenger mobile error -> display error (success false, message failure)
            set_success_status(false, "mobile_error")
            # TODO: other case, raise exception and send email to administrator
          else
            set_success_status(false, "server_error: #{callback.to_s}")
          end
        end

        # Sets the success status
        def set_success_status(success_or_failure, status_code)
          self.success = success_or_failure
          self.status = status_code
        end
  end
end
