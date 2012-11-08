require 'test_helper'

module Sms
  class MessageTest < ActiveSupport::TestCase
    test "Detection of China mobile" do
      china_sms = Sms::Message.new(country_code: '86')
      us_sms = Sms::Message.new(country_code: '1')
      assert china_sms.china_mobile?
      assert !us_sms.china_mobile?
    end

    test "Successful message delivery to China mobile" do
      china_sms = Sms::Message.new(country_code: '86', mobile_number: '15652411388', content: 'test')
      assert china_sms.deliver!
      assert_equal '0', china_sms.status_code
    end

    test "Failed message delivery to wrong China mobile" do
      china_sms = Sms::Message.new(country_code: '86', mobile_number: '1565241138', content: 'test')
      assert china_sms.deliver!
      assert_equal '1', china_sms.status_code
    end

    # test "Failed message delivery to China mobile due to server error" do
    #   china_sms = Sms::Message.new(country_code: '86', mobile_number: '15652411388', content: 'test')
    #   assert china_sms.deliver!
    #   assert_equal 2, china_sms.status_code
    # end

    test "Successful message delivery to international mobile" do
      singapore_sms = Sms::Message.new(country_code: '65', mobile_number: '97724982', content: 'test')
      assert singapore_sms.deliver!
      assert_equal '0', singapore_sms.status_code
    end
  end
end
