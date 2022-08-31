# Installation
Add gem to your Gemfile and run bundle
```ruby
gem 'payoneer-rb'
```

# Usage
## Configuration
All of the following properties have to be set in order for gem to work properly
```ruby
# config/initializers/payoneer.rb

Payoneer.configure do |c|
  c.environment = # payoneer env (:sandbox (default) | :production)
  c.callback_url = # callback url used for sending auth codes (Optional)
  c.program_id = # program id
end
```

## Examples

### Create signup url
```ruby
Payoneer::Payee.create_link(params: { payee_id: '<payee_id>' })
```

### Create a payout
```ruby
Payoneer::Payout.create(
  payment_id: '<internal_payment_ref>',
  payee_id: '<payee_id>',
  amount: 170.45,
  description: '',
  currency: 'USD'
)
```

### Check the program balance
```ruby
Payoneer::Program.balance
```
