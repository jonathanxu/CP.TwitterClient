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
// disabled
- (instancetype)init;
// default initializer
- (instancetype)initWithUser:(CPUser *)user;

- (void)fetch:(NSUInteger)count
      sinceId:(NSUInteger)sinceId
        maxId:(NSUInteger)maxId
      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
