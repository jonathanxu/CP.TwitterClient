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
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@end

@implementation CPDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.title = @"Tweet";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    if (self.model.retweeted_by) {
        self.retweetedByLabel.text = [[NSString alloc] initWithFormat:@"%@ retweeted", self.model.retweeted_by];
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
    
    [self adjustButton:self.replyButton imageName:@"reply" onState:NO];
    [self adjustButton:self.retweetButton imageName:@"retweet" onState:self.model.retweeted];
    [self adjustButton:self.favoriteButton imageName:@"favorite" onState:self.model.favorited];
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

- (void)adjustButton:(UIButton *)button
           imageName:(NSString *)imageName
             onState:(BOOL)onState
{
    [button setTitle:nil forState:UIControlStateNormal];
    NSMutableString *imageNameSelected = [[NSMutableString alloc] initWithString:imageName];
    if (onState) {
        [imageNameSelected appendString:@"_on"];
    }
    [button setBackgroundImage:[UIImage imageNamed:imageNameSelected] forState:UIControlStateNormal];
}

#pragma mark - actions

- (IBAction)touchReply
{
    NSLog(@"CPDetailViewController.touchReply");
}

- (IBAction)touchRetweet
{
    NSLog(@"CPDetailViewController.touchRetweet");
    BOOL retweeted = [self.model toggleRetweet];
    [self adjustButton:self.retweetButton imageName:@"retweet" onState:retweeted];
}

- (IBAction)touchFavorite
{
    NSLog(@"CPDetailViewController.touchFavorite");
    BOOL favorited = [self.model toggleFavorite];
    [self adjustButton:self.favoriteButton imageName:@"favorite" onState:favorited];
}

@end
