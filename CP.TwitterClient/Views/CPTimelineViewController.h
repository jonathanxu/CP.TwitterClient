//
//  CPTimelineViewController.h
//  CP.TwitterClient
//
//  Created by Jonathan Xu on 2/1/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPUser.h"

@interface CPTimelineViewController : UITableViewController
@property (weak, nonatomic) CPUser *currentUser;
@end
