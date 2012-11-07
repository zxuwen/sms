# Sets your api key settings for smsbao, nexmo

smsbao_config= YAML.load_file("config/smsbao.yml")[Rails.env]
#nexmo_config = YAML.load_file("config/nexmo.yml")[Rails.env]
#raise 'You have not created config/smsbao.yml and config/nexmo.yml' if (smsbao_config.empty? || nexmo_config.empty?)

Sms::SmsbaoGateway.set_account(smsbao_config['username'], smsbao_config['password'])
