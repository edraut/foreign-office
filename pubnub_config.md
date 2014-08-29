---
layout: default
---

## Rather Use Pubnub? We don't judge.
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

####in your javascript manifest...

```javascript
//= require foreign_office
```

####in any javscript file you like:

```javascript
foreign_office.config({
  bus_name: 'PubnubBus',
  publish_key: '<YOUR PUBNUB PUBLISH KEY>',
  subscribe_key: '<YOUR PUBNUB SUBSCRIBE KEY>',
  ssl: true
});
```
