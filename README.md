## CodePath Week 3 Homework - Twitter Client

### Launch & Timeline Views

Depends on user login state, app will launch CPLaunchViewController.
  
### Branding

Following Twitter's Branding Guideline: https://about.twitter.com/press/brand-assets

### Twitter OAuth

Use SimpleAuth/Twitter instead of AFNetworking/AFOAuth1Client. SimpleAuth has both `Twitter` and `TwitterWeb`, this app uses `Twitter` which interactives with `Accounts.framework` and `Social.framework`.  `Twitter` mode returns consumer secret and token.