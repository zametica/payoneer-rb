# Installation
Add gem to your Gemfile and run bundle
```ruby
gem 'payoneer-rails'
```

# Usage
## Configuration
All of the following properties have to be set in order for gem to work properly. Please keep them in environment variables if possible.
```ruby
# config/initializers/payoneer.rb

Payoneer.configure do |c|
  c.api_url = # v4 base url (default: https://api.sandbox.payoneer.com/v4)
  c.login_url = # oauth2 login url (default: https://api.sandbox.payoneer.com/v4)
  c.callback_url = # callback url used for sending auth codes
  c.client_id = # client id
  c.client_secret = # client secret
  c.program_id = # program id
end
```

## Examples

### Create signup url
```ruby
Payoneer::Payee::CreateLink.call({ payee_id: '<payee_id>' })
```

### Create a payout
```ruby
Payoneer::Payout::Create.call(
  payment_id: '<internal_payment_ref>',
  payee_id: '<payee_id>',
  amount: 170.45,
  description: '',
  currency: 'USD'
)
```

### Check the program balance
```ruby
Payoneer::Program::Balance.call
```