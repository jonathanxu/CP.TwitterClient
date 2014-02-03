//
//  CPTweet.h
//  CP.TwitterClient
//
//  Created by Jonathan Xu on 2/2/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPTweet : NSObject <NSCoding>

@property (strong, nonatomic) NSString *retweeted_by;

@property (strong, nonatomic) NSString *user__name;
@property (strong, nonatomic) NSString *user__screen_name; // twitter handle
@property (strong, nonatomic) NSString *user__profile_image_url;

@property (nonatomic) NSUInteger retweet_count;
@property (nonatomic) NSUInteger favorite_count;
@property (nonatomic) BOOL retweeted; // by me
@property (nonatomic) BOOL favorited; // by me

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *created_at;
@property (strong, nonatomic) NSString *created_at_abbreviated;

@property (nonatomic) CGFloat viewCellHeightCached;
@property (nonatomic) CGFloat viewTextViewHeightCached;

// disabled initializer
- (instancetype)init;
// default initializer
- (instancetype)initWithDictionary:(NSDictionary *)tweet;

@end
