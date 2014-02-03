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
        [self reload];
    }
}

#pragma mark - bar buttons
- (IBAction)touchSignOutButton:(id)sender
{
    [self.currentUser logout];
    [self.tweets clear];
}

#pragma mark - Table view data source

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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

*/

- (void)reload
{
    [self.apiClient fetch:20
                  sinceId:0
                    maxId:0
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      NSLog(@"CPTimelineViewController.reload: success");
                      [self.tweets reloadTweets:(NSArray *) responseObject];
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"CPTimelineViewController.reload: failure. %@", error);
                  }
     ];
}

@end
