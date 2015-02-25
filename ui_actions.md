---
layout: default
---

## What happens when my client receives a published message?
If you use the base class data-listener="true", then foreign office makes some assumptions about what to do with your message, mostly based on the kind of html element you're binding to.

####Replace the inner html of an element with the value published for your channel/key combo:

```HTML+ERB
<div <%= listener_attrs(@transaction,:grand_total) %>>
</div>
```
This has endless uses. We use it a lot to keep an ajax-heavy page consistent when data is repeated or aggregated multiple times on a page and you don't want to write business logic about relationships on the client.

####Update the href with the published value and click the link:

```HTML+ERB
<a href="#" <%= listener_attrs(@s3_report,:download_url) %>
  data-trigger-on-message="true">
</a>
```

That one is handy if you generate a file in a background worker and need to make the client download as soon as it's done.

If you use [thin_man](http://edraut.github.io/thin-man/) you can also mark your link as an ajax link to have results returned ajax-wise. This is great for having a whole page section refresh or load as a side-effect of some other operation. Say you have a dashboard page for a reservation. You may add guest info as an ajax request on a guest deatils tab. If your server broadcasts the new guest info url as part of the reservation state when it changes, then the dashboard can load the new guest info summary on the overview section as an independent action.

```HTML+ERB
<a <%= listener_attrs(@reservation, :reload_guest_url) %> data-trigger-on-message="true" href="#" <%= ajax_link_attrs('#reservation_guest_summary') %>></a>
<div id="reservation_guest_summary"></div>
```

####Replace an image with the one at the url provided in the published value:

We process images in the background, but would like to populate the thumbnail when it's ready.

```HTML+ERB
<img src="" <%= listener_attrs(@photo,:thumbnail_url) %>>
</img>
```

####Replace the value of a form input with the published value:

This one is useful when mutliple ajax forms exist on a page and each may affect values on the other.

```HTML+ERB
<input type="number" name="total" <%= listener_attrs(@transaction,:total) %>>
```

## Can it do anything fancier than that?

We're so glad you asked.

####Hide or show an element:

```HTML+ERB
<div data-listener="ForeignOfficeRevealer"
  data-channel="MyResource123"
  data-key="deletable?">
  ... some delete form here ...
</div>
```

Don't let users delete an object that shouldn't be deleted, but if it's allowed, then show them the delete button.

####Add new items to a list via ajax:

```HTML+ERB
<div id="my_list"
  data-listener="ForeignOfficeNewListItems"
  data-channel="List_123"
  data-key="new_item_get_url">
</div>
```

This is handy for ajaxy pages that have resources with has_many lists. You might add a new item via ajax that needs to be processed in the background (like sending an email and listing the time/recipient/etc.) If your worker publishes the GET url of the newly created item to your container channel, foreign office will fetch it via ajax and append the results to the list.

##More?

We're excited to extend this to add more behaviors if they seem generally useful. Please let us know what you're looking for and we'll add commonly requested behaviors.

####Write your own behavior

It's pretty easy to extend foreign office to do what you want when you receive a message

```javascript
var ForeignOfficeSquawk = ForeignOfficeListener.extend({
  handleMessage: function(m){
    var current_value = m.object[this.object_key];
    if('squeek' == current_value){
      alert("squeek!!!");
      this.$listener.flash();
    } else if('squawk' == current_value){
      alert("squawk.")
      this.$listener.css({'background-color': 'pink'});
    }
  }
});
```

```HTML+ERB
<div data-listener="ForeignOfficeSquawk"
  data-channel="StrangeBird"
  data-key="utterance">
  Odd duck says...
</div>
```