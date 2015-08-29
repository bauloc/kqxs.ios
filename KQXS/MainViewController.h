//
//  MainViewController.h
//  KQXS
//
//  Created by MAC on 6/23/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController   <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate> {
    
    NSMutableData *responseData;

    
    
    IBOutlet UIBarButtonItem *sidebarButton;
    IBOutlet UIBarButtonItem *btnRefesh;
    
    
    IBOutlet UISegmentedControl *segment;
    
    IBOutlet UITableView *tableView;
    
//    NSMutableArray *lstVeSoMienTrung;
//    NSMutableArray *lstVeSoMienNam;
//    NSMutableArray *lstVeSoMienBac;
    
//    Các tỉnh miền trung
    NSString *mienTrung;
    
};

- (void) CapNhatKQXS;

- (IBAction)DoiMienXoSo:(UISegmentedControl *)sender;

- (IBAction)CapNhatKetQua:(UIBarButtonItem *)sender;


//@property (strong, nonatomic) NSMutableArray *lstVeSo;

@end
