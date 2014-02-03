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
- (void)load;
- (BOOL)persist;
@end

@implementation CPTimelineTweets

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self load];
    }
    return self;
}

- (void)clear
{
    self.tweetList = nil;
    [self persist];
}

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
    [self persist];
}

# pragma mark - private implementation

- (void)load
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *data = (NSData *)[ud objectForKey:kPersistKey];
    self.tweetList = [(NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

- (BOOL)persist
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.tweetList];
    [ud setObject:data forKey:kPersistKey];
    BOOL retVal = [ud synchronize];
    if (retVal) {
        NSLog(@"CPTimelineTweets.persist: success");
    }
    else {
        NSLog(@"CPTimelineTweets.persist: failure");
    }
    return retVal;
}

@end
