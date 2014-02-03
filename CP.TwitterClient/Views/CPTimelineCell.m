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
@end

@implementation CPTimelineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - set model

- (void)setModel:(CPTweet *)tweet
{
    [self.userProfileImage setImageWithURL:[NSURL URLWithString:tweet.user__profile_image_url]];
    
    self.userNameLabel.attributedText = [self attributedName:tweet.user__name screen_name:tweet.user__screen_name];

    self.tweetContentLabel.text = tweet.text;
    self.timeLabel.text = tweet.created_at_abbreviated;
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

@end
