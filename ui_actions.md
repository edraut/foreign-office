---
layout: default
---

## What happens when my client receives a published message?
If you use the base class data-listener="true", then foreign office makes some assumptions about what to do with your message, mostly based on the kind of html element you're binding to.

####Replace the inner html of an element with the value published for your channel/key combo:

```html
<div data-listener="true" data-channel="Transaction_123" data-key="grand_total">
</div>
```
This has endless uses. We use it a lot to keep an ajax-heavy page consistent when data is repeated or aggregated multiple times on a page and you don't want to write business logic about relationships on the client.

####Update the href with the published value and click the link:

```html
<a href="you_win.html"
  data-listener="true"
  data-channel="S3_report_123"
  data-key="download_url"
  data-trigger-on-message="true">
</a>
```

That one is handy if you generate a file in a background worker and need to make the client download as soon as it's done.

####Replace an image with the one at the url provided in the published value:
```html
<img src=""
  data-listener="true"
  data-channel="Photo_123"
  data-key="thumbnail_url">
</img>
```

We process images in the background, but would like to populate the thumbnail when it's ready.

####Replace the value of a form input with the published value:

```html
<input type="number"
  name="total"
  data-listener="true"
  data-channel="Transaction_123"
  data-key="total">
</input>
```
This one is useful when mutliple ajax forms exist on a page and each may affect values on the other.

## Can it do anything fancier than that?
We're so glad you asked.

####Hide or show an element:

```html
<div data-listener="ForeignOfficeRevealer"
  data-channel="MyResource_123"
  data-key="deletable?">
  ... some delete form here ...
</div>
```

Don't let users delete an object that shouldn't be deleted, but if it's allowed, then show them the delete button.

####Add new items to a list via ajax:

```html
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

```html
<div data-listener="ForeignOfficeSquawk"
  data-channel="StrangeBird"
  data-key="utterance">
  Odd duck says...
</div>
```