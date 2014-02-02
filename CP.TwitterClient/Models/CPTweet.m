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

#pragma mark - properties

- (void)setTweet:(NSDictionary *)tweet
{
    _tweet = tweet;

    NSDictionary *userDict = [tweet objectForKey:@"user"];
    self.user__name = [userDict objectForKey:@"name"];
    self.user__screen_name = [userDict objectForKey:@"screen_name"];
    self.user__profile_image_url = [userDict objectForKey:@"profile_image_url"];

    self.retweet_count = [[tweet objectForKey:@"retweet_count"] unsignedIntegerValue];
    self.favorite_count = [[tweet objectForKey:@"favorite_count"] unsignedIntegerValue];
    self.retweeted = [[tweet objectForKey:@"retweeted"] boolValue];
    self.favorited = [[tweet objectForKey:@"favorited"] boolValue];
    
    self.text = [tweet objectForKey:@"text"];
    self.created_at = [tweet objectForKey:@"created_at"];
}

@end
