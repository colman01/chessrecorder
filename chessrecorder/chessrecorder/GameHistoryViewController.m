//
//  GameHistoryViewController.m
//  chessrecorder
//
//  Created by colman on 01/10/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "GameHistoryViewController.h"
#import "AugmentedRealityViewController.h"
#import "HomeViewController.h"

@interface GameHistoryViewController ()

@end

@implementation GameHistoryViewController

@synthesize gameList;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gameList.delegate = self;
    self.fetchedRecordsArray = [[GameDao instance] getAllGames];
    self.gameList.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.gameList.bounds.size.width, 10.01f)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchedRecordsArray.count;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameCell" forIndexPath:indexPath];
 
     DmGameInformation *gameInfo = [self.fetchedRecordsArray objectAtIndex:indexPath.row];
     UILabel *location = (UILabel *)[cell viewWithTag:1];
     UILabel *date = (UILabel *)[cell viewWithTag:2];
     UILabel *time = (UILabel *)[cell viewWithTag:3];
     UILabel *outcome = (UILabel *)[cell viewWithTag:4];
     
     UILabel *white = (UILabel *)[cell viewWithTag:5];
     UILabel *black = (UILabel *)[cell viewWithTag:6];
     
     [location setText:gameInfo.site];
     NSDateFormatter *f = [[NSDateFormatter alloc] init];
     [f setDateFormat:@"yyyy-mmm-dd"];
     [date setText:[f stringFromDate:gameInfo.date]];
     [time setText:@""];
     [white setText:gameInfo.white];
     [black setText:gameInfo.black];
     
     [outcome setText:gameInfo.result];
     
     return cell;
 }

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         // Delete the row from the data source
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
     } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    UITableViewCell *selectedGameCell = (UITableViewCell *)sender;
    NSIndexPath *cellPath = [self.gameList indexPathForCell:selectedGameCell];
    NSNumber *gameNumber = [NSNumber numberWithInteger:cellPath.row];
    
    
    id dest = [segue destinationViewController];
    HomeViewController *home = (HomeViewController *)dest;
    home.showHistory = YES;
    home.gameNumber = gameNumber;
}


@end
