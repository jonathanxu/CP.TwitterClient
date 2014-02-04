//
//  CPTimelineTweets.h
//  CP.TwitterClient
//
//  Created by Jonathan Xu on 2/1/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPUser.h"
#import "CPTweet.h"

@interface CPTimelineTweets : NSObject
- (NSUInteger)count;
- (CPTweet *)tweetAtIndex:(NSUInteger)index;
- (void)reloadTweets:(NSArray *)tweets;
@end
