//
//  CPTwitterAPIClient.m
//  CP.TwitterClient
//
//  Created by Jonathan Xu on 2/1/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import "CPTwitterAPIClient.h"
#import "GCOAuth.h"

static NSString *const kTwitterAPIHOST = @"api.twitter.com";
static NSString *const kTwitterAPITimeline = @"/1.1/statuses/home_timeline.json";
static NSString *const kTwitterAPIFavorite = @"/1.1/favorites/create.json";
static NSString *const kTwitterAPIUnfavorite = @"/1.1/favorites/destroy.json";
static NSString *const kTwitterConsumerKey = @"ans9wMG7I4gicfyaVf7Mkw";
static NSString *const kTwitterConsumerSecret = @"UtC1DWiw4CCYAuHXFEMXfybmYLjq8b753Kmp7pE4OOA";

@interface CPTwitterAPIClient ()
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *accessTokenSecret;
@end

@implementation CPTwitterAPIClient

+ (CPTwitterAPIClient *)sharedInstance
{
    static dispatch_once_t once;
    static CPTwitterAPIClient *instance;
    dispatch_once(&once, ^{
        instance = [[CPTwitterAPIClient alloc] init];
    });
    return instance;
}

- (void)setAccessToken:(NSString *)accessToken secret:(NSString *)secret
{
    self.accessToken = [accessToken copy];
    self.accessTokenSecret = [secret copy];
}

- (void)sendRequestForPath:(NSString *)path
                    method:(NSString *)method
                    params:(NSDictionary *)params
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSURLRequest *request = [GCOAuth URLRequestForPath:path
                                            HTTPMethod:method
                                            parameters:params
                                                scheme:@"https"
                                                  host:kTwitterAPIHOST
                                           consumerKey:kTwitterConsumerKey
                                        consumerSecret:kTwitterConsumerSecret
                                           accessToken:self.accessToken
                                           tokenSecret:self.accessTokenSecret];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:success failure:failure];
    [[NSOperationQueue mainQueue] addOperation:op];
}

- (void)fetch:(NSUInteger)count
      sinceId:(NSUInteger)sinceId
        maxId:(NSUInteger)maxId
      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary *tempParams = @{@"count": [NSString stringWithFormat:@"%d", count]};
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:tempParams];
    if (sinceId > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", sinceId] forKey:@"since_id"];
    }
    if (maxId > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", maxId] forKey:@"max_id"];
    }

    [self sendRequestForPath:kTwitterAPITimeline
                      method:@"GET"
                      params:params
                     success:success
                     failure:failure];
}

- (void)favorite:(long long)tweetId
{
    NSDictionary *params = @{@"id": [[NSString alloc] initWithFormat:@"%lld", tweetId]};
    
    [self sendRequestForPath:kTwitterAPIFavorite
                      method:@"POST"
                          params:params
                         success:nil
                         failure:nil];
}

- (void)unfavorite:(long long)tweetId
{
    NSDictionary *params = @{@"id": [[NSString alloc] initWithFormat:@"%lld", tweetId]};
    
    [self sendRequestForPath:kTwitterAPIUnfavorite
                      method:@"POST"
                      params:params
                     success:nil
                     failure:nil];
}

@end
