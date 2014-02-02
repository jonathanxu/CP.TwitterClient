//
//  CPUser.h
//  CP.TwitterClient
//
//  Created by Jonathan Xu on 1/31/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const UserDidLoginNotification;
extern NSString *const UserDidLogoutNotification;

@interface CPUser : NSObject
- (void)loginWithDictionary:(NSDictionary *)dictionary;
- (BOOL)isLoggedIn;
- (void)logout;
@end
