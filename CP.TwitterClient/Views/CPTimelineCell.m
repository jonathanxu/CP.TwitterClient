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
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
// time
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
// tweet text content
@property (weak, nonatomic) IBOutlet UILabel *tweetContentLabel;
// retweet and favoriate images
@property (weak, nonatomic) IBOutlet UIImageView *retweetImage;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImage;
@end

@implementation CPTimelineCell

#pragma mark - set model

@synthesize model = _model;

- (void)setModel:(CPTweet *)model
{
    _model = model;
    
    [self.userProfileImage setImageWithURL:[NSURL URLWithString:model.user__profile_image_url]];
    
    self.userNameLabel.attributedText = [self attributedName:model.user__name screen_name:model.user__screen_name];

    self.tweetContentLabel.text = model.text;
    self.timeLabel.text = model.created_at_abbreviated;
    
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

- (void)adjustRetweetImage
{
    if (self.model.retweeted) {
        self.retweetImage.image = [UIImage imageNamed:@"retweet_on"];
    }
    else {
        self.retweetImage.image = [UIImage imageNamed:@"retweet"];
    }
}

- (void)adjustFavoriteImage
{
    if (self.model.favorited) {
        self.favoriteImage.image = [UIImage imageNamed:@"favorite_on"];
    }
    else {
        self.favoriteImage.image = [UIImage imageNamed:@"favorite"];
    }
}

@end
