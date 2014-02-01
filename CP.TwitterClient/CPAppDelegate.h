//
//  CPAppDelegate.h
//  CP.TwitterClient
//
//  Created by Jonathan Xu on 1/31/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Models/CPUser.h"

@interface CPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CPUser *currentUser;

@end
