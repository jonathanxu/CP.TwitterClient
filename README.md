## CodePath Week 3 Homework - Twitter Client

### Launch & Timeline Views

Depends on user login state, app will launch CPLaunchViewController.
  
### Branding

Following Twitter's Branding Guideline: https://about.twitter.com/press/brand-assets

### Twitter OAuth

Use SimpleAuth/Twitter instead of AFNetworking/AFOAuth1Client. SimpleAuth has both `Twitter` and `TwitterWeb`, this app uses `Twitter` which interactives with `Accounts.framework` and `Social.framework`.  `Twitter` mode returns consumer secret and token.

It is easy to switch to `TwitterWeb` and pop up a web view for web OAuth flow.

### Calling Twitter API

Once Twitter OAuth credentials are obtained, this app uses GCOAuth (cocoa-oauth) to generate `NSURLRequest` with OAuth signature.

With `NSURLRequest`, AFHTTPRequestOperation is used to make the actual HTTP call.

### Tweet Model

`CPTweet` is a model class that encapsulate a `NSDictionary`. It implements NSCoder protocol in order to be serialized and archived/unarchived.

### Rendering Tweets in table view

Name and screen name are combined and show in a NSAttributedString.

Profile image is rendered asynchronously using UIImageView+AFNetworking.

Time is parsed from Twitter API, and formatted to very short (1h), or short (2/2/14), or long form.  This is done inside model `CPTweet`.

#### Height calculation

- Set UITextView's inset to 0
- Updated UITextView's height constraint via an IBOutlet
- Return table cell's height by calculating the offset from default UITextView height, and add to table cell's default height
- Not using bottom constraint from UITextView to table cell's bottom

#### Touch and Segue

Wire 3 separate touch events for reply, retweet, and faovite. 

Use `CPTimelineViewController.tableView:didSelectRowAtIndexPath` for segue into tweet detail view. This is accomplished with a manual segue, otherwise it would add a segue button to UITableViewCell and mess up layout.

When tweet detail view is popped from the navigation controller, and timeline view is presented, the app will use `viewWillAppear` to fresh current selected row, in case button states have changed in the detail view.

### Retweet and Favorite

- Retweet and Favorite are handled in model (`CPTweet`) with help of `CPTwitterAPIClient`. 
- Most calls are fire-and-forget, with the model updates itself immediately. 
- For retweet, the model supplies a success completion block to retrieve the new retweet id and store on itself, so immediate undo can be performed.
