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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userProfileImageTopMargin;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetAndFavoriteStatsLabel;
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
        [self.retweetedByImage removeFromSuperview];
        [self.retweetedByLabel removeFromSuperview];
        self.userProfileImageTopMargin.constant = 12;
    }
    
    [self.userProfileImage setImageWithURL:[NSURL URLWithString:self.model.user__profile_image_url]];
    self.userNameLabel.text = self.model.user__name;
    self.userScreenNameLabel.text = [@"@" stringByAppendingString:self.model.user__screen_name];
    
    self.contentTextView.text = self.model.text;
    self.contentTextView.textContainer.lineFragmentPadding = 0;
    self.contentTextView.textContainerInset = UIEdgeInsetsZero;
    CGSize size = [self.contentTextView sizeThatFits:CGSizeMake(self.contentTextView.frame.size.width, FLT_MAX)];
    self.contentTextViewHeightConstraint.constant = size.height;
    
    self.createdAtLabel.text = self.model.created_at;
    
    self.retweetAndFavoriteStatsLabel.attributedText = [self attributedStatusWithRetweetCount:self.model.retweet_count favoriteCount:self.model.favorite_count];
}

- (NSAttributedString *)attributedStatusWithRetweetCount:(NSUInteger)retweetCount
                                           favoriteCount:(NSUInteger)favoriteCount
{
    NSMutableAttributedString *attributedStatus = [[NSMutableAttributedString alloc] init];
    
    UIFont *boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0];
    NSDictionary *attributeDict = @{NSFontAttributeName: boldFont,
                                    NSForegroundColorAttributeName:[UIColor blackColor]};
    
    NSString *retweetCountString = [[NSString alloc] initWithFormat:@"%d", retweetCount];
    NSAttributedString *retweetCountAttributedString = [[NSAttributedString alloc] initWithString:retweetCountString attributes:attributeDict];
    
    [attributedStatus appendAttributedString:retweetCountAttributedString];
    
    [attributedStatus appendAttributedString:[[NSAttributedString alloc] initWithString:@" RETWEETS     "]];

    NSString *favoriteCountString = [[NSString alloc] initWithFormat:@"%d", favoriteCount];
    NSAttributedString *favoriteCountAttributedString = [[NSAttributedString alloc] initWithString:favoriteCountString attributes:attributeDict];
    
    [attributedStatus appendAttributedString:favoriteCountAttributedString];

    [attributedStatus appendAttributedString:[[NSAttributedString alloc] initWithString:@" FAVORITES"]];

    return attributedStatus;
}

@end
