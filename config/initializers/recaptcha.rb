# config/initializers/recaptcha.rb
Recaptcha.configure do |config|
  config.public_key  = '6Le8AiQTAAAAAFhrsKkyunZyORxo31DGKu62afiC'
  config.private_key =  Rails.application.secrets.recaptcha_secret_key
  config.hostname = HOST
# Uncomment the following line if you are using a proxy server:
# config.proxy = 'http://myproxy.com.au:8080'
end
