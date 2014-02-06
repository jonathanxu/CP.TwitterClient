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
static NSString *const kTwitterAPIRetweetWithFormat = @"/1.1/statuses/retweet/%@.json";
static NSString *const kTwitterAPIUndoRetweetWithFormat = @"/1.1/statuses/destroy/%@.json";
static NSString *const kTwitterAPIFavorite = @"/1.1/favorites/create.json";
static NSString *const kTwitterAPIUnfavorite = @"/1.1/favorites/destroy.json";
static NSString *const kTwitterAPITweet = @"/1.1/statuses/update.json";

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
    NSDictionary *tempParams = @{@"include_my_retweet": @"true",
                                 @"count": [NSString stringWithFormat:@"%d", count]};
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

- (void)retweet:(NSString *)tweetId
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
{
    NSString *path = [[NSString alloc] initWithFormat:kTwitterAPIRetweetWithFormat, tweetId];
    
    [self sendRequestForPath:path
                      method:@"POST"
                      params:nil
                     success:success
                     failure:nil];
}

- (void)undoRetweet:(NSString *)retweetId; // NOTE: this is the *re*tweetId
{
    NSString *path = [[NSString alloc] initWithFormat:kTwitterAPIUndoRetweetWithFormat, retweetId];
    
    [self sendRequestForPath:path
                      method:@"POST"
                      params:nil
                     success:nil
                     failure:nil];
}

- (void)favorite:(NSString *)tweetId
{
    [self sendRequestForPath:kTwitterAPIFavorite
                      method:@"POST"
                          params:@{@"id": tweetId}
                         success:nil
                         failure:nil];
}

- (void)unfavorite:(NSString *)tweetId
{
    [self sendRequestForPath:kTwitterAPIUnfavorite
                      method:@"POST"
                      params:@{@"id": tweetId}
                     success:nil
                     failure:nil];
}

- (void)tweet:(NSString *)text inReplyToTweetId:(NSString *)inReplyToTweetId
      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:text forKey:@"status"];
    if (inReplyToTweetId) {
        [params setObject:inReplyToTweetId forKey:@"in_reply_to_status_id"];
    }

    [self sendRequestForPath:kTwitterAPITweet
                      method:@"POST"
                      params:params
                     success:success
                     failure:nil];
}

@end
