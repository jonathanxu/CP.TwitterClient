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
#import "CPComposeViewController.h"

@interface CPTimelineViewController ()
@property (strong, nonatomic) CPTimelineTweets *tweets;
@end

@implementation CPTimelineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"CPTimelineViewController.viewDidLoad");

    self.clearsSelectionOnViewWillAppear = NO;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSLog(@"CPTimelineViewController.viewWillAppear");

    if (!self.tweets) {
        self.tweets = [[CPTimelineTweets alloc] init];
        [self reload];
    }
    else {
        // http://stackoverflow.com/questions/3747842/reload-uitableview-when-navigating-back
        // refresh selected row, useful for popping the detail view out, and back to timeline view
        NSIndexPath *selectedRowIndexPath = [self.tableView indexPathForSelectedRow];
        if (selectedRowIndexPath) {
            [self.tableView reloadRowsAtIndexPaths:@[selectedRowIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

#pragma mark - bar buttons
- (IBAction)touchSignOutButton:(id)sender
{
    [[CPUser sharedInstance] logout];
    self.tweets = nil;
}

- (IBAction)touchNew:(id)sender
{
    CPComposeViewController *composeVC = [[CPComposeViewController alloc] init];
    composeVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    composeVC.dismissAfterComposeDelegate = self;
    [self presentViewController:composeVC animated:YES completion:nil];
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
    cell.replyActionDelegate = self;
    
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
        detailVC.dismissAfterComposeDelegate = self;
    }
}

#pragma mark - CPDismissAfterComposeDelegate

- (void)dismissWithTweets:(NSArray *)newTweets
{
    NSLog(@"CPTimelineViewController.dismissWithTweets");
    
    NSUInteger count = [newTweets count];
    if (count > 0) {
        [self.tweets addTweetsAtBeginning:newTweets];

        NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:count];
        for (int i = 0; i < count; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationTop];
    }
}

#pragma mark - CPReplyActionDelegate

- (void)reply:(CPTweet *)tweet
{
    if (tweet) {
        CPComposeViewController *composeVC = [[CPComposeViewController alloc] init];
        composeVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        composeVC.inReplyToTweetId = tweet.tweetId;
        composeVC.inReplyToScreenName = tweet.user__screen_name;
        composeVC.dismissAfterComposeDelegate = self;
        [self presentViewController:composeVC animated:YES completion:nil];
    }
}

#pragma mark - reload data

- (void)reload
{
    CPTwitterAPIClient *apiClient = [CPTwitterAPIClient sharedInstance];
    [apiClient fetch:20
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
