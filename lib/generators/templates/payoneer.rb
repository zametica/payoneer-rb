Payoneer.configure do |config|
  # Set the payoneer env
  # Options - :sandbox | :production
  config.environment = :sandbox

  # Set the callback url for sending the auth codes
  # config.callback_url = https://my-site.com/payoneer

  # Set the client id for basic auth
  # config.client_id =

  # Set the client secret for basic auth
  # config.client_secret =

  # Set the program id
  # config.program_id =
end
