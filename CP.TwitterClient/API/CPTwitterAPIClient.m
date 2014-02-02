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
static NSString *const kTwitterConsumerKey = @"ans9wMG7I4gicfyaVf7Mkw";
static NSString *const kTwitterConsumerSecret = @"UtC1DWiw4CCYAuHXFEMXfybmYLjq8b753Kmp7pE4OOA";

@interface CPTwitterAPIClient ()
@property (weak, nonatomic) CPUser *user;
@end

@implementation CPTwitterAPIClient

- (instancetype)init
{
    return nil;
}

- (instancetype)initWithUser:(CPUser *)user
{
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
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

    NSURLRequest *request = [GCOAuth URLRequestForPath:kTwitterAPITimeline
                                            HTTPMethod:@"GET"
                                            parameters:params
                                                scheme:@"https"
                                                  host:kTwitterAPIHOST
                                           consumerKey:kTwitterConsumerKey
                                        consumerSecret:kTwitterConsumerSecret
                                           accessToken:self.user.accessToken
                                           tokenSecret:self.user.accessTokenSecret];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:success failure:failure];
    [[NSOperationQueue mainQueue] addOperation:op];
}

@end
