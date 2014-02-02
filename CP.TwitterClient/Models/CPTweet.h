//
//  CPTweet.h
//  CP.TwitterClient
//
//  Created by Jonathan Xu on 2/2/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPTweet : NSObject <NSCoding>
// disabled initializer
- (instancetype)init;
// default initializer
- (instancetype)initWithDictionary:(NSDictionary *)tweet;
@end
