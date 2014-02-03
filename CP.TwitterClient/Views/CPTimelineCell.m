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
    self.userNameLabel.text = tweet.user__name;
    self.tweetContentLabel.text = tweet.text;
}

@end
