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
    self.tweetList = [tweets mutableCopy];
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

- (void)addTweetsAtEnd:(NSArray *)tweets
{
    if (tweets) {
        if (!self.tweetList) {
            self.tweetList = [[NSMutableArray alloc] initWithArray:tweets];
        }
        else {
            // drop repeat tweet
            CPTweet *lastOld = (CPTweet *)[self.tweetList lastObject];
            if (lastOld) {
                CPTweet *firstNew = (CPTweet *)[tweets firstObject];
                if ([lastOld.tweetId isEqualToString:firstNew.tweetId]) {
                    [self.tweetList removeLastObject];
                }
            }
            [self.tweetList addObjectsFromArray:tweets];
        }
    }
}

- (NSString *)getNewestTweetId
{
    CPTweet *tweet = [self.tweetList firstObject];
    return tweet.tweetId;
}

- (NSString *)getOldestTweetId
{
    CPTweet *tweet = [self.tweetList lastObject];
    return tweet.tweetId;
}

@end
