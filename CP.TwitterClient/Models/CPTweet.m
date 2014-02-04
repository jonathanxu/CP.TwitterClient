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
@property (strong, nonatomic) NSDate *tweetDate;
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

// cache NSDateFormatter, it is not cheap
static NSDateFormatter * sTwitterDateFormatter;
+ (NSDateFormatter *)getTwitterDateFormatter
{
    if (!sTwitterDateFormatter) {
        sTwitterDateFormatter = [[NSDateFormatter alloc] init];
        // Twitter's Date format: @"Mon Feb 03 01:02:57 +0000 2014"
        [sTwitterDateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss vvvv yyyy"];
    }
    return sTwitterDateFormatter;
}
static NSDateFormatter * sShortDateFormatter;
+ (NSDateFormatter *)getShortDateFormatter
{
    if (!sShortDateFormatter) {
        sShortDateFormatter = [[NSDateFormatter alloc] init];
        // Twitter's Date format: @"Mon Feb 03 01:02:57 +0000 2014"
        [sShortDateFormatter setDateFormat:@"dd/MM/yy HH:mm a"];
    }
    return sShortDateFormatter;
}
static NSDateFormatter * sVeryShortDateFormatter;
+ (NSDateFormatter *)getVeryShortDateFormatter
{
    if (!sVeryShortDateFormatter) {
        sVeryShortDateFormatter = [[NSDateFormatter alloc] init];
        // Twitter's Date format: @"Mon Feb 03 01:02:57 +0000 2014"
        [sVeryShortDateFormatter setDateFormat:@"dd/MM/yy"];
    }
    return sVeryShortDateFormatter;
}

- (void)setTweet:(NSDictionary *)tweet
{
    _tweet = tweet;

    int r = arc4random() % 2;
    if (r == 0) {
        self.retweeted_by = @"Test";
    }
    
    NSDictionary *userDict = [tweet objectForKey:@"user"];
    self.user__name = [userDict objectForKey:@"name"];
    self.user__screen_name = [userDict objectForKey:@"screen_name"];
    self.user__profile_image_url = [userDict objectForKey:@"profile_image_url"];

    self.retweet_count = [[tweet objectForKey:@"retweet_count"] unsignedIntegerValue];
    self.favorite_count = [[tweet objectForKey:@"favorite_count"] unsignedIntegerValue];
    self.retweeted = [[tweet objectForKey:@"retweeted"] boolValue];
    self.favorited = [[tweet objectForKey:@"favorited"] boolValue];
    
    self.text = [tweet objectForKey:@"text"];
    self.viewCellHeightCached = 0;
    self.viewTextViewHeightCached = 0;

    self.tweetDate = [[CPTweet getTwitterDateFormatter] dateFromString:[tweet objectForKey:@"created_at"]];
    self.created_at = [[CPTweet getShortDateFormatter] stringFromDate:self.tweetDate];
}

@synthesize created_at_abbreviated = _created_at_abbreviated;

- (NSString *)created_at_abbreviated
{
    NSTimeInterval interval = [self.tweetDate timeIntervalSinceNow];
    interval = interval * (-1);
    if (interval < 60.0) {
        return @"Just now";
    }
    else if (interval < 3600.0) {
        return [[NSString alloc] initWithFormat:@"%dm", (int)round(interval / 60.0)];
    }
    else if (interval < 86400.0) {
        return [[NSString alloc] initWithFormat:@"%dh", (int)round(interval / 3600.0)];
    }
    else {
        return [[CPTweet getVeryShortDateFormatter] stringFromDate:self.tweetDate];
    }
}

@end
