//
//  CPTimelineTweets.m
//  CP.TwitterClient
//
//  Created by Jonathan Xu on 2/1/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import "CPTimelineTweets.h"

static NSString *const kPersistKey = @"CP.TwitterClient.CPTimelineTweets";

@interface CPTimelineTweets ()
@property (strong, nonatomic) NSMutableArray *tweetList;
@end

@implementation CPTimelineTweets

- (NSUInteger)count
{
    return [self.tweetList count];
}

- (CPTweet *)tweetAtIndex:(NSUInteger)index
{
    return [self.tweetList objectAtIndex:index];
}

- (void)reloadTweets:(NSArray *)tweets
{
    self.tweetList = [[NSMutableArray alloc] initWithCapacity:[tweets count]];
    for (NSDictionary *tweet in tweets) {
        [self.tweetList addObject:[[CPTweet alloc] initWithDictionary:tweet]];
    }
}

- (void)addTweetsAtBeginning:(NSArray *)tweets
{
    if (tweets) {
        if (!self.tweetList) {
            self.tweetList = [[NSMutableArray alloc] initWithArray:tweets];
        }
        else {
            NSRange range = NSMakeRange(0, [tweets count]);
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:range];
            [self.tweetList insertObjects:tweets atIndexes:indexSet];
        }
    }
}

@end
