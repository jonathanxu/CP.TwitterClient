//
//  CPTimelineViewController.m
//  CP.TwitterClient
//
//  Created by Jonathan Xu on 2/1/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import "CPTimelineViewController.h"
#import "CPTimelineTweets.h"
#import "CPTwitterAPIClient.h"
#import "CPTimelineCell.h"

@interface CPTimelineViewController ()

@property (strong, nonatomic) CPTimelineTweets *tweets;
@property (strong, nonatomic) CPTwitterAPIClient *apiClient;

- (void)reload;

@end

@implementation CPTimelineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    self.apiClient = [[CPTwitterAPIClient alloc] initWithUser:self.currentUser];
    self.tweets = [[CPTimelineTweets alloc] init];
    if ([self.tweets count] == 0) {
        [self doRefresh];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"CPTimelineViewController:viewDidAppear");
}

#pragma mark - bar buttons
- (IBAction)touchSignOutButton:(id)sender
{
    [self.currentUser logout];
    [self.tweets clear];
}

#pragma mark - Table view data source

- (IBAction)refresh
{
    [self doRefresh];
    
}

- (void)doRefresh
{
    [self reload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
    CPTimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.model = [self.tweets tweetAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"CPTimelineViewController.tableView:didSelectRowAtIndexPath: %d", indexPath.row);
}

# pragma mark - reload data

- (void)reload
{
    [self.apiClient fetch:20
                  sinceId:0
                    maxId:0
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      NSLog(@"CPTimelineViewController.reload: success");
                      [self.tweets reloadTweets:(NSArray *) responseObject];
                      [self.tableView reloadData];
                      [self.refreshControl endRefreshing];
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"CPTimelineViewController.reload: failure. %@", error);
                  }
     ];
}

@end
