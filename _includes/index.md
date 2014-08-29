---
---

### Install it

In your gemfile:
```
gem 'foreign_office'
```

### Configure it
```ruby
ForeignOffice.config(
  bus: {
    klass: ForeignOffice::Busses::PusherBus,
    app_id: <YOUR PUSHER APP ID>,
    key: <YOUR PUSHER KEY>,
    secret: <YOUR PUSHER SECRET>
    })
```
in your javascript manifest...
```javascript
//= require foreign_office
```
in any javscript file you like:
```javascript
foreign_office.config({
  bus_name: 'PusherBus',
  key: '<YOUR PUSHER KEY>'
});
```
#### Rather Use Pubnub? We don't judge.
```ruby
ForeignOffice.config(
  bus: {
    klass: ForeignOffice::Busses::PubnubBus,
    publish_key: <YOUR PUBNUB_PUBLISH_KEY>,
    subscribe_key: <YOUR PUBNUB_SUBSCRIBE_KEY>,
    secret_key: <YOUR PUBNUB_SECRET_KEY>
    }
)
```
in any javscript file you like:
```javascript
foreign_office.config({
  bus_name: 'PubnubBus',
  publish_key: '<YOUR PUBNUB PUBLISH KEY>',
  subscribe_key: '<YOUR PUBNUB SUBSCRIBE KEY>',
  ssl: true
});
```

#### want to wrap the http call to the bus?
```ruby
ForeignOffice.config(
  bus: {
    klass: ForeignOffice::Busses::PusherBus,
    app_id: <YOUR PUSHER APP ID>,
    key: <YOUR PUSHER KEY>,
    secret: <YOUR PUSHER SECRET>
    }),
  publish_method: ->(message){
    ConeyIsland.submit(ForeignOffice, :publish!, args: [message.stringify_keys!], work_queue: 'cyclone')
  })
```

### Create a Listener
```html
<div data-listener="true" data-channel="Transaction_123" data-key="grand_total"></div>
```
### Publish a message
```ruby
ForeignOffice.publish(channel: "Transaction_#{@transaction.id}", object: {grand_total: @transaction.grand_total})
```

That's it!

### Want more integrations?
Send us your ideas. Better yet, send us a pull request on github!
* want a different bus?
* want a new subscription event js behavior?


### Authors and Contributors
Along with Eric Draut (@edraut), Adam Bialek (@abialek) is a core contributor.
