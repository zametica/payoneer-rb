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

### Create a signup url
```ruby
> response = Payoneer::Payee.create_link(params: { payee_id: '<payee_id>' })
=> #<Payoneer::Response:0x0000000106404708 @body={"registration_link"=>"http://example.com"}>
> response.registration_link
=> "http://example.com"
```
Use `{ existing: true }` if you want to generate a link for an existing user.
Use `{ consent: true }` if user needs to be redirected to consent flow after registration/login. Note: `callback_url` has to be specified for this feature to work.

### Get the payee status
```ruby
> response = Payoneer::Payee.status(payee_id: 1)
=> #<Payoneer::Response:0x000000010c58fc20 @body={"status"=>"Active"}>
> response.status
=> 'Active'
```

### Get the payee details
```ruby
> response = Payoneer::Payee.details(payee_id: 1)
=> #<Payoneer::Response:0x0000000111ce6640 @body={"account_id"=>"5510700", "type"=>"INDIVIDUAL", "contract"=>{"email"=>"demo008@yopmail.com"}, "address"=>{"city"=>"Berlin"}}>
> response.contact[:email]
=> "demo008@yopmail.com"
> response.address['city']
=> 'Berlin'
```

### Release the payee
```ruby
> response = Payoneer::Payee.release(payee_id: 1)
=> #<Payoneer::Response:0x00000001110e7060 @body={"payee_id"=>"12345"}>
```

### Create a payout
```ruby
> response = Payoneer::Payout.create(
  payment_id: '123abc',
  payee_id: '1',
  amount: 170.45,
  description: '',
  currency: 'USD'
)
=> #<Payoneer::Response:0x0000000106eb58a0 @body={"result"=>"Payments Created", "payment_id"=>"123abc"}>
```
Please keep in mind this an async process. Additional validation is being applied on Payoneer side.
For payment status check use `.status` method described bellow.

### Check the payout status
```ruby
> response = Payoneer::Payout.status(payment_id: '123abc')
=> #<Payoneer::Payout::Status:0x000000011005dac8 @body={"status"=>"Pending", "payment_id"=>"123abc"}>
> response_failed = Payoneer::Payout.status(payment_id: 'abc123')
=> #<Payoneer::Payout::Status:0x0000000107a66a28 @body={"status"=>"Failed", "payment_id"=>"abc123", "error"=>{"description"=>"Server Error", "reason"=>nil}}>
> response_failed.error['description']
=> 'Server Error'
```

### Check the program balance
```ruby
> response = Payoneer::Program.balance
=> #<Payoneer::Response:0x0000000109d53b80 @body={"balance"=>50.0, "currency"=>"USD"}>
```
