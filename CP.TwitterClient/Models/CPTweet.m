//
//  CPTweet.m
//  CP.TwitterClient
//
//  Created by Jonathan Xu on 2/2/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import "CPTweet.h"

@interface CPTweet ()
@property (strong, nonatomic) NSDictionary *tweet;
@end

@implementation CPTweet

// disabled initializer
- (instancetype)init
{
    return nil;
}

// default initializer
- (instancetype)initWithDictionary:(NSDictionary *)tweet
{
    self = [super init];
    if (self) {
        self.tweet = tweet;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aCoder
{
    self = [super init];
    if (self) {
        self.tweet = [aCoder decodeObject];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.tweet];
}

@end
