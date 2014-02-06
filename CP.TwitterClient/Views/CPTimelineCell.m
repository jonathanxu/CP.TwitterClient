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
        self.retweetByNameLabel.text = [[NSString alloc] initWithFormat:@"%@ retweeted", self.model.retweeted_by];
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
    // remove left padding and inset so we could properly calculate tableView:heightForRowAtIndexPath
    self.contentTextView.textContainerInset = UIEdgeInsetsZero;
    self.contentTextView.textContainer.lineFragmentPadding = 0;
    if (model.viewTextViewHeightCached == 0) {
        CGSize size = [self.contentTextView sizeThatFits:CGSizeMake(self.contentTextView.frame.size.width, FLT_MAX)];
        model.viewTextViewHeightCached = size.height;
    }
    self.contentTextViewHeightConstraint.constant = model.viewTextViewHeightCached;
    
    self.timeLabel.text = model.created_at_abbreviated;
    
    [self adjustButton:self.replyButton imageName:@"reply" onState:NO];
    [self adjustButton:self.retweetButton imageName:@"retweet" onState:self.model.retweeted];
    [self adjustButton:self.favoriteButton imageName:@"favorite" onState:self.model.favorited];
}

- (NSAttributedString *)attributedName:(NSString *)name screen_name:(NSString *)screen_name
{
    NSString *handle = [NSString stringWithFormat:@"@%@", screen_name];
    NSString *combined = [name stringByAppendingFormat:@"  %@", handle];
    
    NSMutableAttributedString *attributedName = [[NSMutableAttributedString alloc] initWithString:combined attributes:nil];
    
    // make name bold
    UIFont *boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0];
    [attributedName setAttributes:@{NSFontAttributeName: boldFont}
                            range:[combined rangeOfString:name]];
    
    // change color for handle
    UIFont *smallerFont = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    UIColor *halfBlack = [UIColor colorWithRed:128.0/255.0
                                         green:128.0/255.0
                                          blue:128.0/255.0
                                         alpha:1];
    // search for screen_name backwards, in case screen name may be a substring of name, or the same as name
    [attributedName setAttributes:@{NSForegroundColorAttributeName: halfBlack,
                                    NSFontAttributeName: smallerFont
                                   }
                            range:[combined rangeOfString:handle
                                                  options:NSBackwardsSearch]];
    return attributedName;
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

#pragma mark - touch reply, retweet, favorite

- (IBAction)touchReply
{
    NSLog(@"CPTimelineCell.touchReply");
    [self.replyActionDelegate reply:self.model];
}

- (IBAction)touchRetweet
{
    NSLog(@"CPTimelineCell.touchRetweet");
    BOOL retweeted = [self.model toggleRetweet];
    [self adjustButton:self.retweetButton imageName:@"retweet" onState:retweeted];
}

- (IBAction)touchFavorite
{
    NSLog(@"CPTimelineCell.touchFavorite");
    BOOL favorited = [self.model toggleFavorite];
    [self adjustButton:self.favoriteButton imageName:@"favorite" onState:favorited];
}

@end
