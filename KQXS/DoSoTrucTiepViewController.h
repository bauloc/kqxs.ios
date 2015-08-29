//
//  DoSoTrucTiepViewController.h
//  KQXS
//
//  Created by MAC on 6/23/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoSoTrucTiepViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UIBarButtonItem  *sidebarButton;
    
    IBOutlet UIView *vwDoSo;
    IBOutlet UIView *vwTrungSo;
    
    IBOutlet UIImageView *ivIcon;
    IBOutlet UILabel *lblTieuDe;
    IBOutlet UILabel *lblNoiDung;

    
    NSArray *thuhai;
    NSArray *thuba;
    NSArray *thutu;
    NSArray *thunam;
    NSArray *thusau;
    NSArray *thubay;
    NSArray *chunhat;
    
}

@property (strong, nonatomic) IBOutlet UITextField *txtDate;

@property (strong, nonatomic) IBOutlet UITextField *txtTinhThanhPho;

@property (strong, nonatomic) IBOutlet UITextField *txtSoCanDo;


@property (strong, nonatomic) IBOutlet UITableView *tableview;


- (IBAction)btnDoSo:(UIButton *)sender;


- (IBAction)ThayDoiSoCanDo:(UITextField *)sender;


- (IBAction)txtChonNgayEditingEnd:(UITextField *)sender;

- (IBAction)CapNhatKQXS:(UITextField *)sender;


@end
