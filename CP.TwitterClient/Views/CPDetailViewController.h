//
//  CPDetailViewController.h
//  CP.TwitterClient
//
//  Created by Jonathan Xu on 2/2/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTweet.h"

@interface CPDetailViewController : UIViewController
@property (weak, nonatomic) CPTweet *model;
@end
