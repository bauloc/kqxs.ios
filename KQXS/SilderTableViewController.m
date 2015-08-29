//
//  SilderTableViewController.m
//  KQXS
//
//  Created by MAC on 6/23/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Social/Social.h>


#import "SilderTableViewController.h"
#import "SWRevealViewController.h"
#import "PXAlertView.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>


#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface SilderTableViewController ()

@end

@implementation SilderTableViewController{
    NSArray *menuItems;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];

    
    self.tableView.tableFooterView =   [UIView new];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    menuItems = @[@"mnDoSoTrucTiep", @"mnKQHienTai", @"mnThongKe", @"mnFacebook", @"mnAbout", @"mnMoreApp"];
    
 /*   UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_menu.png"]];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
    
   */
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

 
    
    if( indexPath.section == 1 && indexPath.row == 2) {
        
        [self.revealViewController revealToggleAnimated:YES];

    
        [PXAlertView showAlertWithTitle:@"Thông báo" message:@"Tính năng này đang được phát triển, sẽ được cập nhật ở các phiển bản sau."];
        
    }
    
    if( indexPath.section == 2 && indexPath.row == 2) {
        
        exit(0);
    }
    
    if( indexPath.section == 2 && indexPath.row == 0) {
        
        [self.revealViewController revealToggleAnimated:YES];
        
//        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
//        content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"];
        
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        
        content.imageURL=[NSURL URLWithString:@"http://4.bp.blogspot.com/-4XIENbbV238/VbspvwrzbHI/AAAAAAAAXLo/Xa-Lerv5nhk/s1600/IMG_1101.png"];

        
        content.contentDescription = @"Bạn mua vé số, bạn không biết cách so sánh vé số, bạn chưa hiểu được giá trị các giải mà bạn có thể trúng số. Bạn chỉ cần nhập dãy số trên vé số của bạn vào ô quay số và chọn ngày mở thưởng của tỉnh thành mà bạn tham gia, chương trình sẽ tự động cập nhật, thống kê và đưa ra cho bạn biết kết quả";
        
        content.contentTitle = @"Ứng dụng Xổ Số Ba Miền (Android + iOS)";
        
        content.contentURL = [NSURL URLWithString:@"http://bk-power.blogspot.com/2015/07/ung-dung-xo-so-ba-mien.html"];
        [FBSDKShareDialog showFromViewController:self
                                     withContent:content
                                        delegate:nil];
        
    }
    
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

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


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];

    /*
    
    // Set the photo if it navigates to the PhotoView
    if ([segue.identifier isEqualToString:@"showPhoto"]) {
        PhotoViewController *photoController = (PhotoViewController*)segue.destinationViewController;
        NSString *photoFilename = [NSString stringWithFormat:@"%@_photo.jpg", [menuItems objectAtIndex:indexPath.row]];
        photoController.photoFilename = photoFilename;
    }
     
     */
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
}




- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(20, 8, 320, 20);
    myLabel.font = [UIFont fontWithName:@"UVNHuongQueBold" size:18];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}


@end
