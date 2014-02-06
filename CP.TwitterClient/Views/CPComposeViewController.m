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
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tweetButton;

@property (strong, nonatomic) UIColor *enabledBarButtonColor;
@property (strong, nonatomic) UIColor *halfBlack;
@end

@implementation CPComposeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CPUser *currentUser = [CPUser sharedInstance];
    [self.myImage setImageWithURL:[NSURL URLWithString:currentUser.profileImageUrl]];
    self.myNameLabel.text = currentUser.name;
    self.myScreenNameLabel.text = [@"@" stringByAppendingString:currentUser.screenName];
    self.tweetTextView.keyboardType = UIKeyboardTypeTwitter;
    self.tweetTextView.delegate = self;
    
    self.enabledBarButtonColor = [UIColor colorWithRed:0.0/255.0
                                                 green:122.0/255.0
                                                  blue:255.0/255.0
                                                 alpha:1];
    self.halfBlack = [UIColor colorWithRed:128.0/255.0
                                     green:128.0/255.0
                                      blue:128.0/255.0
                                     alpha:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tweetTextView becomeFirstResponder];
    [self updateCharacterCount:self.tweetTextView];
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

- (IBAction)touchTweet:(id)sender
{
    int characterRemaining = 140 - self.tweetTextView.text.length;
    if (characterRemaining >= 0) {
        NSLog(@"CPComposeViewController.touchTweet");
    }
}

# pragma mark - input, update character count

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateCharacterCount:textView];
}

- (void)updateCharacterCount:(UITextView *)textView
{
    
    int characterRemaining = 140 - textView.text.length;
    self.characterCountLabel.text = [[NSString alloc] initWithFormat:@"%d", characterRemaining];
    if (characterRemaining < 0) {
        self.characterCountLabel.textColor = [UIColor redColor];
        self.tweetButton.tintColor = self.halfBlack;
    }
    else {
        self.characterCountLabel.textColor = self.halfBlack;
        self.tweetButton.tintColor = self.enabledBarButtonColor;
    }
}

@end
