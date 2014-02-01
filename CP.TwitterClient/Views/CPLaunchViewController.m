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

@end

@implementation CPLaunchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"CPLaunchViewController.viewDidLoad");
}

- (IBAction)touchLoginButton
{
    NSLog(@"CPLaunchViewController.touchLoginButton");
    
    NSDictionary *key = @{@"consumer_key": @"ans9wMG7I4gicfyaVf7Mkw",
                          @"consumer_secret": @"UtC1DWiw4CCYAuHXFEMXfybmYLjq8b753Kmp7pE4OOA"
                         };
    SimpleAuth.configuration[@"twitter"] = key;
    [SimpleAuth authorize:@"twitter" completion:^(id responseObject, NSError *error) {
        NSLog(@"SimpleAuth.authorize:completion: %@", responseObject);
    }];
}

@end
