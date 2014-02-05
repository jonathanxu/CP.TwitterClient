//
//  CPTwitterAPIClient.h
//  CP.TwitterClient
//
//  Created by Jonathan Xu on 2/1/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "CPUser.h"

@interface CPTwitterAPIClient : NSObject

+ (CPTwitterAPIClient *)sharedInstance;

- (void)setAccessToken:(NSString *)accessToken secret:(NSString *)secret;

- (void)fetch:(NSUInteger)count
      sinceId:(NSUInteger)sinceId
        maxId:(NSUInteger)maxId
      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)favorite:(long long)tweetId;
- (void)unfavorite:(long long)tweetId;

@end
