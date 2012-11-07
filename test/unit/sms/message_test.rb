require 'test_helper'
    SMSBAO_USERNAME = "Hopcab"
    SMSBAO_PASSWORD = "Wrsoq4j7lee"

Sms::SmsbaoGateway.set_account(SMSBAO_USERNAME, SMSBAO_PASSWORD)

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
      assert_equal 0, china_sms.status_code
    end

    test "Failed message delivery to wrong China mobile" do
      china_sms = Sms::Message.new(country_code: '86', mobile_number: '1565241138', content: 'test')
      assert china_sms.deliver!
      assert_equal 1, china_sms.status_code
    end

    test "Failed message delivery to China mobile due to server error" do
      china_sms = Sms::Message.new(country_code: '86', mobile_number: '15652411388', content: 'test')
      assert china_sms.deliver!
      assert_equal 2, china_sms.status_code
    end
    # test "the truth" do
    #   assert true
    # end
  end
end
