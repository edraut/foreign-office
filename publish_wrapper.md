---
layout: default
---

## want to wrap the http call to the bus?
```ruby
ForeignOffice.config(
  bus: {
    ...your bus configurationi here...
    }),
  publish_method: ->(message){
    MyInstrumenter do
      ForeignOffice.publish! channel: 'exclamations_to_everyone', object: {shout_out: 'Hello world!'}
    end
  })
```

You can run any code you like here, but you must eventually call ForeignOffice.publish! with the same hash containing channel and object keys as usual.
This is good if you want to:

* send publish requests in a background worker (e.g. your worker system has significantly lower latency than your push bus because it's on the same local network)
* instrument publish requests with some special custom logging
* post every message you publish to Facebook (well, someone will want to, casting all good judgement to the wind)