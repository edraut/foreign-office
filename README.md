## Install it

In your gemfile:

```ruby
gem 'foreign_office'
```

## Configure it
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
If you'd rather use Pubnub, see [here](http://edraut.github.io/foreign-office/pubnub_config.html).

If you'd like to wrap each publish request so you can background it or instrument it, then see [here](http://edraut.github.io/foreign-office/publish_wrapper.html).

## Let's use it!
#### Create a Listener
```html
<div data-listener="true" data-channel="Transaction_123" data-key="grand_total">
</div>
```
#### Publish a message
```ruby
ForeignOffice.publish(
  channel: "Transaction_#{@transaction.id}",
  object: {grand_total: @transaction.grand_total})
```

After you publish, your div will show the latest grand total via browser-push. Your server can update your client on demand!

See [here](http://edraut.github.io/foreign-office/ui_actions.html) for all the ui actions you can trigger when you receive a message.

## Want more integrations?
Send us your ideas. Better yet, send us a pull request on github!

* want a different bus?
* want a new subscription event js behavior?


## Authors and Contributors
Along with Eric Draut (@edraut), Adam Bialek (@abialek) and Matt Leonard (@mattleonard) are core contributors.
