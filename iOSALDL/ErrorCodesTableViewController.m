//
//  ErrorCodesTableViewController.m
//  iOSALDL
//
//  Created by rpasek on 10/15/20.
//

#import "ErrorCodesTableViewController.h"
#import "BoolDataTableViewCell.h"
#import "ECU.h"

@interface ErrorCodesTableViewController ()

@end

@implementation ErrorCodesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ALDLStrings->ErrorCodesStrings.Num;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section < ALDLStrings->ErrorCodesStrings.Num ? @(ALDLStrings->ErrorCodesStrings.Items[section].Name) : nil;
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section < ALDLStrings->ErrorCodesStrings.Num ? ALDLStrings->ErrorCodesStrings.Items[section].Strings.Num : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BoolDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BoolDataTableViewCell" forIndexPath:indexPath];
    
    cell.lblName.text = (indexPath.section < ALDLStrings->ErrorCodesStrings.Num && indexPath.row < ALDLStrings->ErrorCodesStrings.Items[indexPath.section].Strings.Num) ? @(ALDLStrings->ErrorCodesStrings.Items[indexPath.section].Strings.Items[indexPath.row]) : nil;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
