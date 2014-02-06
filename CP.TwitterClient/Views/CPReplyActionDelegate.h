//
//  CPReplyActionDelegate.h
//  CP.TwitterClient
//
//  Created by Jonathan Xu on 2/6/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPTweet.h"

@protocol CPReplyActionDelegate <NSObject>
- (void)reply:(CPTweet *)tweet;
@end
