//
//  CPComposeViewController.m
//  CP.TwitterClient
//
//  Created by Jonathan Xu on 2/5/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import "CPComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "CPUser.h"

@interface CPComposeViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UILabel *myNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *myScreenNameLabel;
@end

@implementation CPComposeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CPUser *currentUser = [CPUser sharedInstance];
    [self.myImage setImageWithURL:[NSURL URLWithString:currentUser.profileImageUrl]];
    self.myNameLabel.text = currentUser.name;
    self.myScreenNameLabel.text = [@"@" stringByAppendingString:currentUser.screenName];
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
