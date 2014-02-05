//
//  CPComposeViewController.m
//  CP.TwitterClient
//
//  Created by Jonathan Xu on 2/5/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import "CPComposeViewController.h"

@interface CPComposeViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@end

@implementation CPComposeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

# pragma mark - UIBarPositioningDelegate

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

# pragma mark - bar button actions

- (IBAction)touchCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
