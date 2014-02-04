//
//  CPTimelineCell.m
//  CP.TwitterClient
//
//  Created by Jonathan Xu on 2/2/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import "CPTimelineCell.h"
#import "UIImageView+AFNetworking.h"

@interface CPTimelineCell ()
// top retweet-by UI elements
@property (weak, nonatomic) IBOutlet UIImageView *retweetByImage;
@property (weak, nonatomic) IBOutlet UILabel *retweetByNameLabel;
// user UI elements
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userProfileImageTopMargin;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
// time
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
// tweet text content
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTextViewHeightConstraint;
// reply, retweet, and favoriate buttons
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@end

@implementation CPTimelineCell

#pragma mark - set model

@synthesize model = _model;

- (void)setModel:(CPTweet *)model
{
    _model = model;
    
    if (self.model.retweeted_by) {
        self.retweetByImage.hidden = NO;
        self.retweetByNameLabel.hidden = NO;
        self.retweetByNameLabel.text = self.model.retweeted_by;
        self.userProfileImageTopMargin.constant = 34;
    }
    else {
        self.retweetByImage.hidden = YES;
        self.retweetByNameLabel.hidden = YES;
        self.retweetByNameLabel.text = nil;
        self.userProfileImageTopMargin.constant = 10;
    }

    [self.userProfileImage setImageWithURL:[NSURL URLWithString:model.user__profile_image_url]];
    
    self.userNameLabel.attributedText = [self attributedName:model.user__name screen_name:model.user__screen_name];

    self.contentTextView.text = model.text;
    // remove inset so we could properly calculate tableView:heightForRowAtIndexPath
    [self.contentTextView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    if (model.viewTextViewHeightCached == 0) {
        CGSize size = [self.contentTextView sizeThatFits:CGSizeMake(self.contentTextView.frame.size.width, FLT_MAX)];
        model.viewTextViewHeightCached = size.height;
    }
    self.contentTextViewHeightConstraint.constant = model.viewTextViewHeightCached;
    
    self.timeLabel.text = model.created_at_abbreviated;
    
    [self adjustReplyImage];
    [self adjustRetweetImage];
    [self adjustFavoriteImage];
}

- (NSAttributedString *)attributedName:(NSString *)name screen_name:(NSString *)screen_name
{
    NSString *handle = [NSString stringWithFormat:@"@%@", screen_name];
    NSString *combined = [name stringByAppendingFormat:@"  %@", handle];
    
    NSMutableAttributedString *attributedName = [[NSMutableAttributedString alloc] initWithString:combined attributes:nil];
    
    // make name bold
    UIFont *boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0];
    [attributedName setAttributes:@{NSFontAttributeName:boldFont}
                            range:[combined rangeOfString:name]];
    
    // change color for handle
    UIColor *halfBlack = [UIColor colorWithRed:128.0/255.0
                                         green:128.0/255.0
                                          blue:128.0/255.0
                                         alpha:1];
    // search for screen_name backwards, in case screen name may be a substring of name, or the same as name
    [attributedName setAttributes:@{NSForegroundColorAttributeName:halfBlack}
                            range:[combined rangeOfString:handle
                                                  options:NSBackwardsSearch]];
    return attributedName;
}

- (void)adjustReplyImage
{
    [self.replyButton setTitle:@"" forState:UIControlStateNormal];
    [self.replyButton setBackgroundImage:[UIImage imageNamed:@"reply"] forState:UIControlStateNormal];
}

- (void)adjustRetweetImage
{
    [self.retweetButton setTitle:@"" forState:UIControlStateNormal];
    if (self.model.retweeted) {
        [self.retweetButton setBackgroundImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
    }
    else {
        [self.retweetButton setBackgroundImage:[UIImage imageNamed:@"retweet"] forState:UIControlStateNormal];
    }
}

- (void)adjustFavoriteImage
{
    [self.favoriteButton setTitle:@"" forState:UIControlStateNormal];
    if (self.model.favorited) {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
    }
    else {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
    }
}

#pragma mark - touch reply, retweet, favorite

- (IBAction)touchReply
{
    NSLog(@"CPTimelineCell.touchReply");
}

- (IBAction)touchRetweet
{
    NSLog(@"CPTimelineCell.touchRetweet");
}

- (IBAction)touchFavorite
{
    NSLog(@"CPTimelineCell.touchFavorite");
}

@end
