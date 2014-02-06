//
//  CPComposeViewController.h
//  CP.TwitterClient
//
//  Created by Jonathan Xu on 2/5/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTweet.h"
#import "CPDismissAfterComposeDelegate.h"

@interface CPComposeViewController : UIViewController <UIBarPositioningDelegate, UITextViewDelegate>
@property (weak, nonatomic) id <CPDismissAfterComposeDelegate> dismissAfterComposeDelegate;
@property (strong, nonatomic) NSString *inReplyToTweetId;
@end
