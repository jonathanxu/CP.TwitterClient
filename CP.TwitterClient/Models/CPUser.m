//
//  CPUser.m
//  CP.TwitterClient
//
//  Created by Jonathan Xu on 1/31/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import "CPUser.h"
#import "CPTwitterAPIClient.h"

NSString *const UserDidLoginNotification = @"UserDidLoginNotification";
NSString *const UserDidLogoutNotification = @"UserDidLogoutNotification";

static NSString *const kPersistKey = @"CP.TwitterClient.CPUser";

@interface CPUser ()
@property (strong, nonatomic) NSDictionary *authAttributes;
- (void)setAuthAttributes:(NSDictionary *)authAttributes;
- (NSDictionary *)load;
- (BOOL)persist;
@end

@implementation CPUser

+ (CPUser *)sharedInstance
{
    static dispatch_once_t once;
    static CPUser *instance;
    dispatch_once(&once, ^{
        instance = [[CPUser alloc] init];
        [instance load];
    });
    return instance;
}

#pragma mark - auth attributes, and persistence

@synthesize authAttributes = _authAttributes;

- (void)setAuthAttributes:(NSDictionary *)authAttributes
{
    if (![_authAttributes isEqualToDictionary:authAttributes]) {
        NSLog(@"CPUser.setAttributes: changed");
        _authAttributes = authAttributes;
        NSDictionary *credentials = [authAttributes objectForKey:@"credentials"];
        if (credentials) {
            self.accessToken = [credentials objectForKey:@"token"];
            self.accessTokenSecret = [credentials objectForKey:@"secret"];
        }
        else {
            self.accessToken = nil;
            self.accessTokenSecret = nil;
        }
        
        CPTwitterAPIClient *apiClient = [CPTwitterAPIClient sharedInstance];
        [apiClient setAccessToken:self.accessToken
                           secret:self.accessTokenSecret];
    }
}

- (NSDictionary *)load
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *data = (NSData *)[ud objectForKey:kPersistKey];
    self.authAttributes = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    return self.authAttributes;
}

- (BOOL)persist
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.authAttributes];
    [ud setObject:data forKey:kPersistKey];
    BOOL retVal = [ud synchronize];
    if (retVal) {
        NSLog(@"CPUser.persist: success");
    }
    else {
        NSLog(@"CPUser.persist: failure");
    }
    return retVal;
}

#pragma mark - login, logout

- (void)loginWithDictionary:(NSDictionary *)dictionary
{
    self.authAttributes = dictionary;
    [self persist];

    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:nil];
}

- (BOOL)isLoggedIn
{
    return ([self.authAttributes objectForKey:@"credentials"] != nil);
}

- (void)logout
{
    self.authAttributes = nil;
    [self persist];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}

@end
