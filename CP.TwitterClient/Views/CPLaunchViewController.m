//
//  CPLaunchViewController.m
//  CP.TwitterClient
//
//  Created by Jonathan Xu on 1/31/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import "CPLaunchViewController.h"
#import "SimpleAuth.h"

@interface CPLaunchViewController ()
@property (weak, nonatomic) IBOutlet UILabel *loginErrorLabel;
@end

@implementation CPLaunchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"CPLaunchViewController.viewDidLoad");
    self.loginErrorLabel.hidden = YES;
    self.loginErrorLabel.text = @"Sorry, login failed. Please check Twitter section in your phone's Settings.";
}

- (IBAction)touchLoginButton
{
    NSLog(@"CPLaunchViewController.touchLoginButton");
    self.loginErrorLabel.hidden = YES;
    
    NSDictionary *key = @{@"consumer_key": @"ans9wMG7I4gicfyaVf7Mkw",
                          @"consumer_secret": @"UtC1DWiw4CCYAuHXFEMXfybmYLjq8b753Kmp7pE4OOA"
                         };
    SimpleAuth.configuration[@"twitter"] = key;
    [SimpleAuth authorize:@"twitter" completion:^(id responseObject, NSError *error) {
        if (error) {
            NSLog(@"SimpleAuth.authorize:completion: error, %@", error);
            self.loginErrorLabel.hidden = NO;
        } else {
            NSLog(@"SimpleAuth.authorize:completion: success");
            [self.currentUser loginWithDictionary:responseObject];
        }
    }];
}

@end
