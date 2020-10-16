//
//  FlagDataTableViewController.m
//  iOSALDL
//
//  Created by rpasek on 10/16/20.
//

#import "FlagDataTableViewController.h"
#import "RawDataViewController.h"
#import "BoolDataTableViewCell.h"

@interface FlagDataTableViewController ()

@end

@implementation FlagDataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return FlagDataStringsLen;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section < FlagDataStringsLen ? @(FlagDataStrings[section]) :nil ;
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return MW2StringsLen;
        case 1:
            return MWAF1StringsLen;
        case 2:
            return MCU2IOStringsLen;
        default:
            return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BoolDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BoolDataTableViewCell" forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
            cell.lblName.text = indexPath.row < MW2StringsLen ? @(MW2Strings[indexPath.row]) : nil;
            break;
        case 1:
            cell.lblName.text = indexPath.row < MWAF1StringsLen ? @(MWAF1Strings[indexPath.row]) : nil;
            break;
        case 2:
            cell.lblName.text = indexPath.row < MCU2IOStringsLen ? @(MCU2IOStrings[indexPath.row]) : nil;
            break;
    }
    
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
