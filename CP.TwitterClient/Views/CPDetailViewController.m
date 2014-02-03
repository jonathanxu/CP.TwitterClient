//
//  CPDetailViewController.m
//  CP.TwitterClient
//
//  Created by Jonathan Xu on 2/2/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import "CPDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface CPDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *retweetedByImage;
@property (weak, nonatomic) IBOutlet UILabel *retweetedByLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetContentLabel;
@end

@implementation CPDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.title = @"Tweet";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    if (self.model.retweeted_by) {
        self.retweetedByLabel.text = self.model.retweeted_by;
    }
    else {
        self.retweetedByImage.hidden = YES;
        self.retweetedByLabel.hidden = YES;
        [self.retweetedByImage removeFromSuperview];
        [self.retweetedByLabel removeFromSuperview];
    }
    
    [self.userProfileImage setImageWithURL:[NSURL URLWithString:self.model.user__profile_image_url]];
    self.userNameLabel.text = self.model.user__name;
    self.userScreenNameLabel.text = [@"@" stringByAppendingString:self.model.user__screen_name];
    self.tweetContentLabel.text = self.model.text;
    
}

@end
