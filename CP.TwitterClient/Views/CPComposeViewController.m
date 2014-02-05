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
@property (weak, nonatomic) IBOutlet UITextField *tweetTextField;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;
@end

@implementation CPComposeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CPUser *currentUser = [CPUser sharedInstance];
    [self.myImage setImageWithURL:[NSURL URLWithString:currentUser.profileImageUrl]];
    self.myNameLabel.text = currentUser.name;
    self.myScreenNameLabel.text = [@"@" stringByAppendingString:currentUser.screenName];
    self.tweetTextField.keyboardType = UIKeyboardTypeTwitter;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tweetTextField becomeFirstResponder];
    [self updateCharacterCount];
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

# pragma mark - input, update character count
- (IBAction)tweetTextFieldEditingChanged:(id)sender
{
    [self updateCharacterCount];
}

- (void)updateCharacterCount
{
    int characterRemaining = 140 - self.tweetTextField.text.length;
    self.characterCountLabel.text = [[NSString alloc] initWithFormat:@"%d", characterRemaining];
}

@end
