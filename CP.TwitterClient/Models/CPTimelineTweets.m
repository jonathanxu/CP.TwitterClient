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
@property (strong, nonatomic) NSMutableArray *tweets;
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
    self.tweets = nil;
    [self persist];
}

- (NSUInteger)count
{
    return [self.tweets count];
}

# pragma mark - private implementation

- (void)load
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *data = (NSData *)[ud objectForKey:kPersistKey];
    self.tweets = [(NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

- (BOOL)persist
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.tweets];
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
