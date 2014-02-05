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
#import "CPDetailViewController.h"

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
 
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    self.apiClient = [[CPTwitterAPIClient alloc] initWithUser:self.currentUser];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"CPTimelineViewController:viewDidAppear");
    if (!self.tweets) {
        self.tweets = [[CPTimelineTweets alloc] init];
        [self reload];
    }
}

#pragma mark - bar buttons
- (IBAction)touchSignOutButton:(id)sender
{
    [self.currentUser logout];
    self.tweets = nil;
}

#pragma mark - Table view data source

- (IBAction)refresh
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

    CPTweet *model = [self.tweets tweetAtIndex:indexPath.row];
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPTweet *model = [self.tweets tweetAtIndex:indexPath.row];

    if (model.viewCellHeightCached == 0) {
        // 64 is left margin, 10 is right margin of TextView
        CGFloat width = self.view.frame.size.width - 64 - 10;

        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
        NSDictionary *attributes = @{NSFontAttributeName: font};
        CGRect frame = [model.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:attributes
                                                context:nil];

        // 125 is default cell height, 37 is default TextView height
        model.viewCellHeightCached = 125 + (frame.size.height - 37);
        
        if (!model.retweeted_by) {
            // 34 - 10 = 24 is the difference between having and not having retweet line
            model.viewCellHeightCached -= 24;
        }
    }
        
    return model.viewCellHeightCached;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"CPTimelineViewController.tableView:didSelectRowAtIndexPath: %d", indexPath.row);
    
    CPTweet *tweet = [self.tweets tweetAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"tweetDetailSeque" sender:tweet];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"tweetDetailSeque"])
    {
        CPDetailViewController *detailVC = [segue destinationViewController];
        detailVC.model = (CPTweet *)sender;
    }
}

# pragma mark - reload data

- (void)reload
{
    [self.apiClient fetch:25
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
