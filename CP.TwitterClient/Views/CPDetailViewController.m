//
//  CPDetailViewController.m
//  CP.TwitterClient
//
//  Created by Jonathan Xu on 2/2/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import "CPDetailViewController.h"

@interface CPDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tweetContentLabel;

@end

@implementation CPDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.title = @"Tweet";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.tweetContentLabel.text = self.model.text;
}

@end
