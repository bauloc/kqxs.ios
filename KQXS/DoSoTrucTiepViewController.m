//
//  DoSoTrucTiepViewController.m
//  KQXS
//
//  Created by MAC on 6/23/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

//http://www.kqxs.vn/do-ket-qua/?date=02-07-2015


#import "DoSoTrucTiepViewController.h"
#import "SWRevealViewController.h"
#import "PXAlertView.h"
#import "kqxsCellMienNam.h"
#import "VeSo.h"
#import "HTMLNode.h"

#import "MBProgressHUD.h"

#import "Reachability.h"




VeSo *veSo;

UIPickerView *yourpicker;

UIAlertView *alert;
NSString *urlDoKQXS;

NSDateFormatter *formatter;


NSDateFormatter *dateFormatter;
NSDate *date;


NSMutableArray *lstVeSo;

MBProgressHUD *HUD;


@interface DoSoTrucTiepViewController ()

@end

@implementation DoSoTrucTiepViewController


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    lblNoiDung.font = [UIFont fontWithName:@"Souvenir" size:14.0];
    
    //    Khoi tao cac bien
    dateFormatter = [[NSDateFormatter alloc] init];
    formatter = [[NSDateFormatter alloc] init];
    
    //
    
    vwDoSo.layer.cornerRadius = 5;
    [vwDoSo.layer setBorderColor:[UIColor redColor].CGColor];
    [vwDoSo.layer setBorderWidth:1.0f];
    
    vwTrungSo.layer.cornerRadius = 5;
    [vwTrungSo.layer setBorderColor:[UIColor redColor].CGColor];
    [vwTrungSo.layer setBorderWidth:1.0f];
    
    // Do any additional setup after loading the view.
    
    self.title = @"Dò  Số  Trực  Tiếp";
    
    thuhai = [[NSArray alloc] initWithObjects:@"Thủ Đô", @"Phú Yên", @"Thừa Thiên Huế",@"Hồ Chí Minh",@"Cà Mau",@"Đồng Tháp",nil];
    thuba =  [[NSArray alloc] initWithObjects:@"Quảng Ninh", @"Đack Lac", @"Quảng Nam",@"Bạc Liêu",@"Bến Tre",@"Vũng Tàu",nil];
    thutu = [[NSArray alloc] initWithObjects:@"Bắc Ninh", @"Đà Nẳng", @"Khánh Hòa",@"Cần Thơ",@"Đồng Nai",@"Sóc Trăng",nil];
    thunam = [[NSArray alloc] initWithObjects:@"Thủ Đô", @"Bình Định", @"Quảng Bình",@"Quảng Trị",@"An Giang",@"Bình Thuận",@"Tây Ninh",nil];
    thusau = [[NSArray alloc] initWithObjects:@"Hải Phòng", @"Gia Lai", @"Ninh Thuận",@"Bình Dương",@"Trà Vinh",@"Vĩnh Long", nil];
    thubay = [[NSArray alloc] initWithObjects:@"Nam Định", @"Đà Nẳng", @"Đắc Nông",@"Quảng Ngãi",@"Hồ Chí Minh",@"Bình Phước",@"Hậu Giang",@"Long An",nil];
    chunhat = [[NSArray alloc] initWithObjects:@"Thái Bình", @"Khánh Hòa", @"Kon Tum",@"Kiên Giang",@"Lâm Đồng",@"Tiền Giang",nil];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [sidebarButton setTarget: self.revealViewController];
        [sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
    [formatter setDateFormat:@"dd-MM-yyyy"];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"vi_VN"];
    
    [datePicker addTarget:self action:@selector(updateDateTextField:)
         forControlEvents:UIControlEventValueChanged];
    [self.txtDate setInputView:datePicker];
    
    self.txtDate.text = [formatter stringFromDate:datePicker.date];
    
    
    yourpicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [yourpicker setDataSource: self];
    [yourpicker setDelegate: self];
    yourpicker.showsSelectionIndicator = YES;
    self.txtTinhThanhPho.inputView = yourpicker;
    
    urlDoKQXS = [NSString stringWithFormat:@"http://www.kqxs.vn/do-ket-qua/?date=%@",self.txtDate.text];
    
    //    update du lieu cho txt Tinh Thanh Pho
    [self CapNhatDuLieuChotxtTinhThanhPho];
    
    //    cap nhat du lieu tu website
    urlDoKQXS = [NSString stringWithFormat:@"http://www.kqxs.vn/do-ket-qua/?date=%@",self.txtDate.text];
    
    
    [self CapNhatKQXS];
    
    [self.tableview scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [self.tableview setContentOffset:CGPointZero animated:YES];
    
    
    
}
-(void) CapNhatDuLieuChotxtTinhThanhPho {
    switch ([self NgayTrongTuan]) {
        case 1:
            self.txtTinhThanhPho.text = [chunhat objectAtIndex:0];
            break;
        case 2:
            self.txtTinhThanhPho.text = [thuhai objectAtIndex:0];
            break;
        case 3:
            self.txtTinhThanhPho.text = [thuba objectAtIndex:0];
            break;
        case 4:
            self.txtTinhThanhPho.text = [thutu objectAtIndex:0];
            break;
        case 5:
            self.txtTinhThanhPho.text = [thunam objectAtIndex:0];
            break;
        case 6:
            self.txtTinhThanhPho.text = [thusau objectAtIndex:0];
            break;
        case 7:
            self.txtTinhThanhPho.text = [thubay objectAtIndex:0];
            break;
        default:
            self.txtTinhThanhPho.text = [chunhat objectAtIndex:0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Đoạn code được gọi để cập nhật textview khi chọn trên pickerview
-(void)updateDateTextField:(UIDatePicker *)sender
{
    self.txtDate.text = [formatter stringFromDate:sender.date];
}

//Đoạn code này được gọi để tự động ẩn bàn phím

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (IBAction)btnDoSo:(UIButton *)sender {
    
    
    NSString *giaiDacBiet, *giaiNhat, *giaiNhi, *giaiBa, *giaiTu, *giaiNam, *giaiSau, *giaiBay, *giaiTam;
    NSString *so1, *so2, *so3, *so4, *so5, *so6;
    NSString *soDo1, *soDo2, *soDo3, *soDo4, *soDo5, *soDo6;
    
    NSRange range;
    BOOL trungso = FALSE;
    
    if ( [self KiemTraSoCanDo] ) {
        
        
        if ( [veSo.mien isEqualToString:@"MIENNAM"]) {
            
            giaiTam = [self.txtSoCanDo.text substringFromIndex:4];
            giaiBay = [self.txtSoCanDo.text substringFromIndex:3];
            
            giaiSau = [self.txtSoCanDo.text substringFromIndex:2];
            giaiNam = [self.txtSoCanDo.text substringFromIndex:2];
            
            giaiTu = [self.txtSoCanDo.text substringFromIndex:1];
            giaiBa = [self.txtSoCanDo.text substringFromIndex:1];
            giaiNhi = [self.txtSoCanDo.text substringFromIndex:1];
            giaiNhat = [self.txtSoCanDo.text substringFromIndex:1];
            
            giaiDacBiet = self.txtSoCanDo.text;
            
            NSLog(@"giai gi day ta: %@ %@ %@ %@ %@ %@ %@ %@ %@",giaiTam,giaiBay,giaiSau,giaiNam,giaiTu,giaiBa,giaiNhi,giaiNhat,giaiDacBiet);
            
            
            if ([veSo.giaiTam isEqualToString:giaiTam]) {
                
                trungso = TRUE;
                
                lblNoiDung.text = @"Vé số của bạn đã trúng giải Tám!\nTổng giá trị giải thưởng là 100,000đ";
                
            }
            
            if ([veSo.giaiBay isEqualToString:giaiBay]) {
                
                trungso = TRUE;
                
                lblNoiDung.text = @"Vé số của bạn đã trúng giải Bảy!\nTổng giá trị giải thưởng là 200,000đ";
                
            }
            
            range = [veSo.giaiSau  rangeOfString:giaiSau];
            if (range.location == NSNotFound) {
                NSLog(@"string was not found");
            } else {
                NSLog(@"position %lu", (unsigned long)range.location);
                
                trungso = TRUE;
                
                lblNoiDung.text = @"Vé số của bạn đã trúng giải Sáu!\nTổng giá trị giải thưởng là 400,000đ";
                
            }
            
            if ([veSo.giaiNam isEqualToString:giaiNam]) {
                
                trungso = TRUE;
                
                lblNoiDung.text = @"Vé số của bạn đã trúng giải Năm!\nTổng giá trị giải thưởng là 1,000,000đ";
                
            }
            
            range = [veSo.giaiTu  rangeOfString:giaiTu];
            if (range.location == NSNotFound) {
                NSLog(@"string was not found");
            } else {
                NSLog(@"position %lu", (unsigned long)range.location);
                
                trungso = TRUE;
                
                lblNoiDung.text = @"Vé số của bạn đã trúng giải Tư!\nTổng giá trị giải thưởng là 3,000,000đ";
                
            }
            range = [veSo.giaiBa  rangeOfString:giaiBa];
            if (range.location == NSNotFound) {
                NSLog(@"string was not found");
            } else {
                NSLog(@"position %lu", (unsigned long)range.location);
                
                trungso = TRUE;
                
                lblNoiDung.text = @"Vé số của bạn đã trúng giải Ba!\nTổng giá trị giải thưởng là 10,000,000đ";
                
            }
            
            if ([veSo.giaiNhi isEqualToString:giaiNhi]) {
                
                trungso = TRUE;
                
                lblNoiDung.text = @"Vé số của bạn đã trúng giải Nhì!\nTổng giá trị giải thưởng là 20,000,000đ";
                
            }
            
            if (![veSo.giaiDacBiet isEqualToString:@"?"] ) {
                if ([veSo.giaiNhat isEqualToString:giaiNhat]) {
                    
                    trungso = TRUE;
                    
                    lblNoiDung.text = @"Vé số của bạn đã trúng giải Nhất!\nTổng giá trị giải thưởng là 30,000,000đ";
                    
                }
                
                NSInteger biendem = 0;
                
                so1 = [[giaiDacBiet substringFromIndex:0] substringToIndex:1];
                so2 = [[giaiDacBiet substringFromIndex:1] substringToIndex:1];
                so3 = [[giaiDacBiet substringFromIndex:2] substringToIndex:1];
                so4 = [[giaiDacBiet substringFromIndex:3] substringToIndex:1];
                so5 = [[giaiDacBiet substringFromIndex:4] substringToIndex:1];
                so6 = [[giaiDacBiet substringFromIndex:5] substringToIndex:1];
                
                soDo1 = [[veSo.giaiDacBiet substringFromIndex:0] substringToIndex:1];
                soDo2 = [[veSo.giaiDacBiet substringFromIndex:1] substringToIndex:1];
                soDo3 = [[veSo.giaiDacBiet substringFromIndex:2] substringToIndex:1];
                soDo4 = [[veSo.giaiDacBiet substringFromIndex:3] substringToIndex:1];
                soDo5 = [[veSo.giaiDacBiet substringFromIndex:4] substringToIndex:1];
                soDo6 = [[veSo.giaiDacBiet substringFromIndex:5] substringToIndex:1];
                
                if ([so2 isEqualToString:soDo2]) {
                    biendem +=1;
                }
                if ([so3 isEqualToString:soDo3]) {
                    biendem +=1;
                }
                if ([so4 isEqualToString:soDo4]) {
                    biendem +=1;
                }
                if ([so5 isEqualToString:soDo5]) {
                    biendem +=1;
                }
                if ([so6 isEqualToString:soDo6]) {
                    biendem +=1;
                }
                
                if ([so1 isEqualToString:soDo1] && biendem == 4) {
                    
                    trungso = TRUE;
                    
                    lblNoiDung.text = @"Vé số của bạn đã trúng giải Khuyến Khích!\nTổng giá trị giải thưởng là 6,000,000đ";
                    
                }
                if ([[veSo.giaiDacBiet substringFromIndex:1] isEqualToString:[giaiDacBiet substringFromIndex:1]]) {
                    
                    trungso = TRUE;
                    
                    lblNoiDung.text = @"Vé số của bạn đã trúng giải Phụ!\nTổng giá trị giải thưởng là 100,000,000đ";
                    
                }
                
            }
            
            if ([veSo.giaiDacBiet isEqualToString:giaiDacBiet]) {
                
                trungso = TRUE;
                
                lblNoiDung.text = @"Vé số của bạn đã trúng giải Đặc Biệt!\nTổng giá trị giải thưởng là 1,500,000,000đ";
                
            }
            
        }
        else if ([veSo.mien isEqualToString:@"MIENTRUNG"]) {
            
            giaiTam = [self.txtSoCanDo.text substringFromIndex:4];
            giaiBay = [self.txtSoCanDo.text substringFromIndex:3];
            
            giaiSau = [self.txtSoCanDo.text substringFromIndex:2];
            giaiNam = [self.txtSoCanDo.text substringFromIndex:2];
            
            giaiTu = [self.txtSoCanDo.text substringFromIndex:1];
            giaiBa = [self.txtSoCanDo.text substringFromIndex:1];
            giaiNhi = [self.txtSoCanDo.text substringFromIndex:1];
            giaiNhat = [self.txtSoCanDo.text substringFromIndex:1];
            
            giaiDacBiet = self.txtSoCanDo.text;
            
            
            if ([veSo.giaiTam isEqualToString:giaiTam]) {
                
                trungso = TRUE;
                
                lblNoiDung.text = @"Vé số của bạn đã trúng giải Tám!\nTổng giá trị giải thưởng là 100,000đ";
                
            }
            
            if ([veSo.giaiBay isEqualToString:giaiBay]) {
                
                trungso = TRUE;
                
                lblNoiDung.text = @"Vé số của bạn đã trúng giải Bảy!\nTổng giá trị giải thưởng là 250,000đ";
                
            }
            
            range = [veSo.giaiSau  rangeOfString:giaiSau];
            if (range.location == NSNotFound) {
                NSLog(@"string was not found");
            } else {
                NSLog(@"position %lu", (unsigned long)range.location);
                
                trungso = TRUE;
                
                lblNoiDung.text = @"Vé số của bạn đã trúng giải Sáu!\nTổng giá trị giải thưởng là 500,000đ";
                
            }
            
            if ([veSo.giaiNam isEqualToString:giaiNam]) {
                
                trungso = TRUE;
                
                lblNoiDung.text = @"Vé số của bạn đã trúng giải Năm!\nTổng giá trị giải thưởng là 1,000,000đ";
                
            }
            
            range = [veSo.giaiTu  rangeOfString:giaiTu];
            if (range.location == NSNotFound) {
                NSLog(@"string was not found");
            } else {
                NSLog(@"position %lu", (unsigned long)range.location);
                
                trungso = TRUE;
                
                lblNoiDung.text = @"Vé số của bạn đã trúng giải Tư!\nTổng giá trị giải thưởng là 2,500,000đ";
                
            }
            range = [veSo.giaiBa  rangeOfString:giaiBa];
            if (range.location == NSNotFound) {
                NSLog(@"string was not found");
            } else {
                NSLog(@"position %lu", (unsigned long)range.location);
                
                trungso = TRUE;
                
                lblNoiDung.text = @"Vé số của bạn đã trúng giải Ba!\nTổng giá trị giải thưởng là 5,000,000đ";
                
            }
            
            if ([veSo.giaiNhi isEqualToString:giaiNhi]) {
                
                trungso = TRUE;
                
                lblNoiDung.text = @"Vé số của bạn đã trúng giải Nhì!\nTổng giá trị giải thưởng là 10,000,000đ";
                
            }
            
            if ([veSo.giaiNhat isEqualToString:giaiNhat]) {
                
                trungso = TRUE;
                
                lblNoiDung.text = @"Vé số của bạn đã trúng giải Nhất!\nTổng giá trị giải thưởng là 40,000,000đ";
                
            }
            
            if ( ![veSo.giaiDacBiet isEqualToString:@"?"]) {
                NSInteger biendem = 0;
                
                so1 = [[giaiDacBiet substringFromIndex:0] substringToIndex:1];
                so2 = [[giaiDacBiet substringFromIndex:1] substringToIndex:1];
                so3 = [[giaiDacBiet substringFromIndex:2] substringToIndex:1];
                so4 = [[giaiDacBiet substringFromIndex:3] substringToIndex:1];
                so5 = [[giaiDacBiet substringFromIndex:4] substringToIndex:1];
                so6 = [[giaiDacBiet substringFromIndex:5] substringToIndex:1];
                
                soDo1 = [[veSo.giaiDacBiet substringFromIndex:0] substringToIndex:1];
                soDo2 = [[veSo.giaiDacBiet substringFromIndex:1] substringToIndex:1];
                soDo3 = [[veSo.giaiDacBiet substringFromIndex:2] substringToIndex:1];
                soDo4 = [[veSo.giaiDacBiet substringFromIndex:3] substringToIndex:1];
                soDo5 = [[veSo.giaiDacBiet substringFromIndex:4] substringToIndex:1];
                soDo6 = [[veSo.giaiDacBiet substringFromIndex:5] substringToIndex:1];
                
                if ([so2 isEqualToString:soDo2]) {
                    biendem +=1;
                }
                if ([so3 isEqualToString:soDo3]) {
                    biendem +=1;
                }
                if ([so4 isEqualToString:soDo4]) {
                    biendem +=1;
                }
                if ([so5 isEqualToString:soDo5]) {
                    biendem +=1;
                }
                if ([so6 isEqualToString:soDo6]) {
                    biendem +=1;
                }
                
                if ([so1 isEqualToString:soDo1] && biendem == 4) {
                    
                    trungso = TRUE;
                    
                    lblNoiDung.text = @"Vé số của bạn đã trúng giải Khuyến Khích!\nTổng giá trị giải thưởng là 7,000,000đ";
                    
                }
                if ([[veSo.giaiDacBiet substringFromIndex:1] isEqualToString:[giaiDacBiet substringFromIndex:1]]) {
                    
                    trungso = TRUE;
                    
                    lblNoiDung.text = @"Vé số của bạn đã trúng giải Phụ!\nTổng giá trị giải thưởng là 100,000,000đ";
                    
                }
                if ([veSo.giaiDacBiet isEqualToString:giaiDacBiet]) {
                    
                    trungso = TRUE;
                    
                    lblNoiDung.text = @"Vé số của bạn đã trúng giải Đặc Biệt!\nTổng giá trị giải thưởng là 1,500,000,000đ";
                    
                }

            }
            
            
            
        }
        else {
            
            giaiBay = [self.txtSoCanDo.text substringFromIndex:3];
            
            giaiSau = [self.txtSoCanDo.text substringFromIndex:2];
            
            giaiNam = [self.txtSoCanDo.text substringFromIndex:1];
            giaiTu = [self.txtSoCanDo.text substringFromIndex:1];
            
            giaiBa = self.txtSoCanDo.text;
            giaiNhi = self.txtSoCanDo.text;
            giaiNhat = self.txtSoCanDo.text;
            
            giaiDacBiet = self.txtSoCanDo.text;
            
            NSLog(@"giai: %@ %@ %@ %@ %@ %@ %@ %@",giaiBay,giaiSau,giaiNam,giaiTu,giaiBa,giaiNhi,giaiNhat,giaiDacBiet);
            
            
            range = [veSo.giaiBay  rangeOfString:giaiBay];
            if (range.location == NSNotFound) {
                NSLog(@"string was not found");
            } else {
                NSLog(@"position %lu", (unsigned long)range.location);
                
                trungso = TRUE;
                
                lblNoiDung.text = @"Vé số của bạn đã trúng giải Bảy!\nTổng giá trị giải thưởng là 40,000đ";
                
            }
            
            
            range = [veSo.giaiSau  rangeOfString:giaiSau];
            if (range.location == NSNotFound) {
                NSLog(@"string was not found");
            } else {
                NSLog(@"position %lu", (unsigned long)range.location);
                
                trungso = TRUE;
                
                lblNoiDung.text = @"Vé số của bạn đã trúng giải Sáu!\nTổng giá trị giải thưởng là 100,000đ";
                
            }
            
            range = [veSo.giaiNam  rangeOfString:giaiNam];
            if (range.location == NSNotFound) {
                NSLog(@"string was not found");
            } else {
                NSLog(@"position %lu", (unsigned long)range.location);
                
                trungso = TRUE;
                
                lblNoiDung.text = @"Vé số của bạn đã trúng giải Năm!\nTổng giá trị giải thưởng là 200,000đ";
                
            }
            
            
            range = [veSo.giaiTu  rangeOfString:giaiTu];
            if (range.location == NSNotFound) {
                NSLog(@"string was not found");
            } else {
                NSLog(@"position %lu", (unsigned long)range.location);
                
                trungso = TRUE;
                
                lblNoiDung.text = @"Vé số của bạn đã trúng giải Tư!\nTổng giá trị giải thưởng là 400,000đ";
                
            }
            
            range = [veSo.giaiBa  rangeOfString:giaiBa];
            if (range.location == NSNotFound) {
                NSLog(@"string was not found");
            } else {
                NSLog(@"position %lu", (unsigned long)range.location);
                
                trungso = TRUE;
                
                lblNoiDung.text = @"Vé số của bạn đã trúng giải Ba!\nTổng giá trị giải thưởng là 2,000,000đ";
                
            }
            
            range = [veSo.giaiNhi  rangeOfString:giaiNhi];
            if (range.location == NSNotFound) {
                NSLog(@"string was not found");
            } else {
                NSLog(@"position %lu", (unsigned long)range.location);
                
                trungso = TRUE;
                
                lblNoiDung.text = @"Vé số của bạn đã trúng giải Ba!\nTổng giá trị giải thưởng là 5,000,000đ";
                
            }
            
            
            if ([veSo.giaiNhat isEqualToString:giaiNhat]) {
                
                trungso = TRUE;
                
                lblNoiDung.text = @"Vé số của bạn đã trúng giải Nhất!\nTổng giá trị giải thưởng là 20,000,000đ";
                
            }
            
            if ( ![veSo.giaiDacBiet isEqualToString:@"?"] ) {
                
                if ( [[veSo.giaiDacBiet substringFromIndex:3] isEqualToString:[giaiDacBiet substringFromIndex:3]]) {
                    
                    trungso = TRUE;
                    
                    lblNoiDung.text = @"Vé số của bạn đã trúng giải Khuyến Khích!\nTổng giá trị giải thưởng là 40,000đ";
                    
                }
                
                if ([veSo.giaiDacBiet isEqualToString:giaiDacBiet]) {
                    
                    trungso = TRUE;
                    
                    lblNoiDung.text = @"Vé số của bạn đã trúng giải Đặc Biệt!\nTổng giá trị giải thưởng là 200,000,000đ";
                    
                }
                
            }
  
                     
        }
        
        
        if (trungso) {
            ivIcon.image = [UIImage imageNamed:@"icon_trungso.png"];
            lblTieuDe.text = @"Chúc mừng bạn !";
        } else {
            ivIcon.image = [UIImage imageNamed:@"icon_trunggio.png"];
            lblTieuDe.text = @"Trớt quớt !";
            lblNoiDung.text = @"Rất tiếc! Hệ thống đã dò đi, dò lại nhiều lần mà vẫn không thấy vé của bạn trúng giải nào.\nChúc bạn mai mắn lần sau !";
            
        }
        
    }
    
    /*    NSRange range = [string rangeOfString:searchKeyword];
     if (range.location == NSNotFound) {
     NSLog(@"string was not found");
     } else {
     NSLog(@"position %lu", (unsigned long)range.location);
     }
     */
}
// Thủ Đô Quảng Ninh Bắc Ninh Hải Phòng Nam Định Thái Bình

- (BOOL) KiemTraSoCanDo{
    NSString *mienBac= @"Thủ Đô Quảng Ninh Bắc Ninh Hải Phòng Nam Định Thái Bình";
    NSRange range2 = [mienBac  rangeOfString:self.txtTinhThanhPho.text];
    if (range2.location != NSNotFound) {
        if ([self.txtSoCanDo.text length] !=5) {
            [PXAlertView showAlertWithTitle:@"Không hợp lệ" message:@"Vé số miền Bắc có 5 chữ số !"];
            return FALSE;
        }
    } else {
        if ([self.txtSoCanDo.text length] !=6) {
            [PXAlertView showAlertWithTitle:@"Không hợp lệ" message:@"Vé số bạn cần dò có 6 chữ số !"];
            return FALSE;
        }
    }
    
    return TRUE;
}

- (IBAction)ThayDoiSoCanDo:(UITextField *)sender {
    NSString *mienBac= @"Thủ Đô Quảng Ninh Bắc Ninh Hải Phòng Nam Định Thái Bình";
    NSRange range2 = [mienBac  rangeOfString:self.txtTinhThanhPho.text];
    if (range2.location != NSNotFound) {
        if ([self.txtSoCanDo.text length] !=5) {
            [PXAlertView showAlertWithTitle:@"Không hợp lệ" message:@"Vé số miền Bắc có 5 chữ số !"];
            
        }
    } else {
        if ([self.txtSoCanDo.text length] !=6) {
            [PXAlertView showAlertWithTitle:@"Không hợp lệ" message:@"Vé số bạn cần dò có 6 chữ số !"];
            
        }
    }
}

- (IBAction)txtChonNgayEditingEnd:(UITextField *)sender {
    
    [self CapNhatDuLieuChotxtTinhThanhPho];
    [yourpicker reloadAllComponents];
    
}

- (IBAction)CapNhatKQXS:(UITextField *)sender {
    urlDoKQXS = [NSString stringWithFormat:@"http://www.kqxs.vn/do-ket-qua/?date=%@",self.txtDate.text];
    
    [self CapNhatKQXS];
     //[self.tableview scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [self.tableview setContentOffset:CGPointZero animated:YES];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch ([self NgayTrongTuan]) {
        case 1:
            return [chunhat count];
            break;
        case 2:
            return [thuhai count];
            break;
        case 3:
            return [thuba count];
            break;
        case 4:
            return [thutu count];
            break;
        case 5:
            return [thunam count];
            break;
        case 6:
            return [thusau count];
            break;
        case 7:
            return [thubay count];
            break;
        default:
            return [chunhat count];
            break;
    }
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // NSString *item = [yourItems objectAtIndex:row];
    
     switch ([self NgayTrongTuan]) {
        case 1:
            return [chunhat objectAtIndex:row];
            break;
        case 2:
            return [thuhai objectAtIndex:row];
            break;
        case 3:
            return [thuba objectAtIndex:row];
            break;
        case 4:
            return [thutu objectAtIndex:row];
            break;
        case 5:
            return [thunam objectAtIndex:row];
            break;
        case 6:
            return [thusau objectAtIndex:row];
            break;
        case 7:
            return [thubay objectAtIndex:row];
            break;
        default:
            return [chunhat objectAtIndex:row];
            break;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch ([self NgayTrongTuan]) {
        case 1:
            self.txtTinhThanhPho.text = [chunhat objectAtIndex:row];
            break;
        case 2:
            self.txtTinhThanhPho.text = [thuhai objectAtIndex:row];
            break;
        case 3:
            self.txtTinhThanhPho.text = [thuba objectAtIndex:row];
            break;
        case 4:
            self.txtTinhThanhPho.text = [thutu objectAtIndex:row];
            break;
        case 5:
            self.txtTinhThanhPho.text = [thunam objectAtIndex:row];
            break;
        case 6:
            self.txtTinhThanhPho.text = [thusau objectAtIndex:row];
            break;
        case 7:
            self.txtTinhThanhPho.text = [thubay objectAtIndex:row];
            break;
        default:
            self.txtTinhThanhPho.text = @"Nha Trang";
    }
    
    urlDoKQXS = [NSString stringWithFormat:@"http://www.kqxs.vn/do-ket-qua/?date=%@",self.txtDate.text];
    [self.tableview reloadData];

    
}

-(NSInteger) NgayTrongTuan {
    
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    date = [dateFormatter dateFromString: self.txtDate.text];
    [dateFormatter setDateFormat:@"e"];
    //[dateFormatter setDateFormat:@"EEEEE"];
    
    return [ [dateFormatter stringFromDate:date] intValue];
}


- (void) hmtlParseFormKQXS
{
    
    lstVeSo = [[NSMutableArray alloc] init];
    
    
    NSError *error = nil;
    
    
    NSURL *kqxs= [NSURL URLWithString:urlDoKQXS];
    
    
    //HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    HTMLParser *parser = [[HTMLParser alloc] initWithContentsOfURL:kqxs error:&error];
    
    if (error) {
        alert = [[UIAlertView alloc] initWithTitle:@"Thông Báo"
                                           message:@"Có lỗi xảy ra trong quá trình tải dữ liệu từ server !"
                                          delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
        return; // ngat chuong trinh con, tro ve chuong trinh chinh
    }
    
    HTMLNode *bodyNode = [parser body];
    
    //NSLog(@"body: ");
    //NSLog(@"%@",[bodyNode rawContents]);
    
    NSArray *dsBaMien= [bodyNode findChildrenOfClass:@"kq bggradient1"];
    //NSString *ngayMoThuongMienNam = [[bodyNode findChildOfClass:@"tieude"] allContents];
    
    
    if( [dsBaMien count] < 2) {
        lblTieuDe.text = @"Rất tiếc !";
        lblNoiDung.text = @"Không tìm thấy kết quả cho ngày bạn cần tìm !";
        ivIcon.image = [UIImage imageNamed:@"icon_trunggio.png"];
        
        [self.tableview reloadData];
        
        return;
    }
    
    
    NSArray *ngayMoThuong = [bodyNode findChildrenOfClass:@"tieude"];
    
    NSString *ngayMienNam = [[ngayMoThuong objectAtIndex:1] allContents];
    NSString *ngayMienTrung = [[ngayMoThuong objectAtIndex:2] allContents];
    NSString *ngayMienBac = [[ngayMoThuong objectAtIndex:0] allContents];
    
    
    
    ngayMienNam =  [[ngayMienNam componentsSeparatedByString:@":"] objectAtIndex:1];
    ngayMienTrung =  [[ngayMienTrung componentsSeparatedByString:@":"] objectAtIndex:1];
    ngayMienBac =  [[ngayMienBac componentsSeparatedByString:@":"] objectAtIndex:1];
    
    
    //   ngayMienNam = [[ngayMienNam componentsSeparatedByString:@":"] objectAtIndex:1];
    
    ngayMienNam = [ngayMienNam stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    ngayMienTrung = [ngayMienTrung stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    ngayMienBac = [ngayMienBac stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //NSLog(@"%@",[ [dsBaMien objectAtIndex:0] rawContents]);
    
    for ( HTMLNode *daiMoThuong in dsBaMien) {
        
        VeSo *veSo = [[VeSo alloc] init];
        
        HTMLNode *tenDaiMoThuong = [daiMoThuong findChildOfClass:@"tl-red"];
        veSo.tenDaiMoThuong = [tenDaiMoThuong contents];
        
        //HTMLNode *giaiThuong = [ daiMoThuong findChildWithAttribute:@"text-align: center;" matchingName:@"style" allowPartial:YES];
        //NSLog(@"%@",[giaiThuong contents]);
        
        //NSLog(@"%@",[ daiMoThuong rawContents]);
        
        
        NSMutableArray *soTrungGiai = [[NSMutableArray alloc] init];
        
        
        NSArray *arrayGiaiThuong = [daiMoThuong findChildTags:@"td"];
        
        for (HTMLNode *inputNode in arrayGiaiThuong) {
            if ([inputNode getAttributeNamed:@"style"] != NULL) {
                //  isEqualToString:@"text-align: center;"]
                
                //NSLog(@"%@", [inputNode contents ]); //Answer to first question
                NSString *strResult = [NSString stringWithString:[inputNode contents]];
                strResult = [strResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                //NSLog(@"%@",strResult);
                [soTrungGiai addObject: strResult];
            }
        }

        // Ve so mien Trung va mien Nam
        if (soTrungGiai.count == 9 ) {
            veSo.giaiDacBiet =  [ soTrungGiai objectAtIndex:0];
            veSo.giaiNhat =     [ soTrungGiai objectAtIndex:1];
            veSo.giaiNhi =      [ soTrungGiai objectAtIndex:2];
            veSo.giaiBa =       [ soTrungGiai objectAtIndex:3];
            veSo.giaiTu =       [ soTrungGiai objectAtIndex:4];
            veSo.giaiNam =      [ soTrungGiai objectAtIndex:5];
            veSo.giaiSau =      [ soTrungGiai objectAtIndex:6];
            veSo.giaiBay =      [ soTrungGiai objectAtIndex:7];
            veSo.giaiTam =      [ soTrungGiai objectAtIndex:8];
            
            if ([[tenDaiMoThuong contents] rangeOfString:@"Kon Tum"].location == NSNotFound
                && [[tenDaiMoThuong contents] rangeOfString:@"Khánh Hòa"].location == NSNotFound
                && [[tenDaiMoThuong contents] rangeOfString:@"Phú Yên"].location == NSNotFound
                && [[tenDaiMoThuong contents] rangeOfString:@"Thừa Thiên Huế"].location == NSNotFound
                && [[tenDaiMoThuong contents] rangeOfString:@"Đack Lac"].location == NSNotFound
                && [[tenDaiMoThuong contents] rangeOfString:@"Quảng Nam"].location == NSNotFound
                && [[tenDaiMoThuong contents] rangeOfString:@"Đà Nẳng"].location == NSNotFound
                && [[tenDaiMoThuong contents] rangeOfString:@"Bình Định"].location == NSNotFound
                && [[tenDaiMoThuong contents] rangeOfString:@"Quảng Bình"].location == NSNotFound
                && [[tenDaiMoThuong contents] rangeOfString:@"Quảng Trị"].location == NSNotFound
                && [[tenDaiMoThuong contents] rangeOfString:@"Gia Lai"].location == NSNotFound
                && [[tenDaiMoThuong contents] rangeOfString:@"Ninh Thuận"].location == NSNotFound
                && [[tenDaiMoThuong contents] rangeOfString:@"Đắc Nông"].location == NSNotFound
                && [[tenDaiMoThuong contents] rangeOfString:@"Quảng Ngãi"].location == NSNotFound) {
                
                veSo.mien = @"MIENNAM";
                veSo.ngayMoThuong = ngayMienNam;
                
                
            } else {
                veSo.mien = @"MIENTRUNG";
                veSo.ngayMoThuong = ngayMienTrung;
                
            }
            
            
        }
        // Ve so mien Bac
        if (soTrungGiai.count == 8 ) {
            veSo.giaiDacBiet =  [ soTrungGiai objectAtIndex:0];
            veSo.giaiNhat =     [ soTrungGiai objectAtIndex:1];
            veSo.giaiNhi =      [ soTrungGiai objectAtIndex:2];
            veSo.giaiBa =       [ soTrungGiai objectAtIndex:3];
            veSo.giaiTu =       [ soTrungGiai objectAtIndex:4];
            veSo.giaiNam =      [ soTrungGiai objectAtIndex:5];
            veSo.giaiSau =      [ soTrungGiai objectAtIndex:6];
            veSo.giaiBay =      [ soTrungGiai objectAtIndex:7];
            
            veSo.mien = @"MIENBAC";
            veSo.ngayMoThuong = ngayMienBac;
            
            
        }
        
        [lstVeSo addObject:veSo];
        
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([lstVeSo count] <2) {
        return 0;
    }
    
    return  1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"%d", [lstVeSo count]);
    if ([lstVeSo count] <2) {
        return 0;
    }
    
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    veSo  = [[VeSo alloc] init];
    
    for ( VeSo *veso in lstVeSo) {
        
        NSString *string = veso.tenDaiMoThuong;
        NSRange textRange =[string rangeOfString:self.txtTinhThanhPho.text];
        if(textRange.location != NSNotFound)
        {
            NSLog(@"exists");
            veSo = veso;
        }
        
    }
    
    NSString *simpleTableIdentifier = @"CellMienNam";
    NSArray *nib;
    
    if(  [veSo.mien isEqualToString:@"MIENBAC"]) {
        simpleTableIdentifier = @"CellMienBac";
    }
    
    kqxsCellMienNam *cell = (kqxsCellMienNam *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        
        if(  [veSo.mien isEqualToString:@"MIENBAC"] ) {
            nib = [[NSBundle mainBundle] loadNibNamed:@"kqxsCellMienBac" owner:self options:nil];
        } else {
            nib = [[NSBundle mainBundle] loadNibNamed:@"kqxsCellMienNam" owner:self options:nil];
        }
        
        cell = [nib objectAtIndex:0];
    }
    
    if (veSo.giaiDacBiet == NULL) {
        veSo.giaiDacBiet = @"?";
        
    }
    
    if ( [veSo.giaiDacBiet isEqualToString:@"" ] ) {
        veSo.giaiDacBiet = @"?";
    }
    
    if (veSo.giaiNhat == NULL) {
        veSo.giaiNhat = @"?";
        
    }
    
    if ( [veSo.giaiNhat isEqualToString:@"" ] ) {
        veSo.giaiNhat = @"?";
    }
    
    
    if( [veSo.giaiNhi isEqualToString:@""]){
        veSo.giaiNhi = @"?-?-?-?-?-?-?-?-?-?-?";
    }
    if( [veSo.giaiBa isEqualToString:@""]){
        veSo.giaiBa = @"?-?-?-?-?-?-?-?-?-?-?";
    }
    if( [veSo.giaiTu isEqualToString:@""]){
        veSo.giaiTu = @"?-?-?-?-?-?-?-?-?-?-?";
    }
    if( [veSo.giaiNam isEqualToString:@""]){
        veSo.giaiNam = @"?-?-?-?-?-?-?-?-?-?-?";
    }
    if( [veSo.giaiSau isEqualToString:@""]){
        veSo.giaiSau = @"?-?-?-?-?-?-?-?-?-?-?";
    }
    if( [veSo.giaiBay isEqualToString:@""]){
        veSo.giaiBay = @"?-?-?-?-?-?-?-?-?-?-?";
    }
    
    NSArray *Nhi= [veSo.giaiNhi componentsSeparatedByString:@"-"];
    NSArray *Ba= [veSo.giaiBa componentsSeparatedByString:@"-"];
    NSArray *Tu= [veSo.giaiTu componentsSeparatedByString:@"-"];
    NSArray *Nam= [veSo.giaiNam componentsSeparatedByString:@"-"];
    NSArray *Sau= [veSo.giaiSau componentsSeparatedByString:@"-"];
    NSArray *Bay= [veSo.giaiBay componentsSeparatedByString:@"-"];
    
    cell.lblDaiMoThuong.text = veSo.tenDaiMoThuong;
    cell.lblNgayMoThuong.text= veSo.ngayMoThuong;
    
    cell.lblDaiMoThuong.font = [UIFont fontWithName:@"Souvenir" size:18.0];
    cell.lblNgayMoThuong.font = [UIFont fontWithName:@"UTMAmericanaItalic" size:14];
    
    //cell.lblNgayMoThuong =
    cell.lblGiaiDacBiet.text = veSo.giaiDacBiet;
    cell.lblGiaiNhat.text = veSo.giaiNhat;
    
    cell.lblGiaiTam.text = veSo.giaiTam;
    
    if ([veSo.mien isEqualToString:@"MIENBAC"]) {
        
        
        
        cell.lblGiaiNhi1.text = [Nhi objectAtIndex:0];
        cell.lblGiaiNhi2.text = [Nhi objectAtIndex:1];
        
        cell.lblGiaiBa1.text = [Ba objectAtIndex:0];
        cell.lblGiaiBa2.text = [Ba objectAtIndex:1];
        cell.lblGiaiBa3.text = [Ba objectAtIndex:2];
        cell.lblGiaiBa4.text = [Ba objectAtIndex:3];
        cell.lblGiaiBa5.text = [Ba objectAtIndex:4];
        cell.lblGiaiBa6.text = [Ba objectAtIndex:5];
        
        cell.lblGiaiTu1.text = [Tu objectAtIndex:0];
        cell.lblGiaiTu2.text = [Tu objectAtIndex:1];
        cell.lblGiaiTu3.text = [Tu objectAtIndex:2];
        cell.lblGiaiTu4.text = [Tu objectAtIndex:3];
        
        cell.lblGiaiNam1.text = [Nam objectAtIndex:0];
        cell.lblGiaiNam2.text = [Nam objectAtIndex:1];
        cell.lblGiaiNam3.text = [Nam objectAtIndex:2];
        cell.lblGiaiNam4.text = [Nam objectAtIndex:3];
        cell.lblGiaiNam5.text = [Nam objectAtIndex:4];
        cell.lblGiaiNam6.text = [Nam objectAtIndex:5];
        
        cell.lblGiaiSau1.text = [Sau objectAtIndex:0];
        cell.lblGiaiSau2.text = [Sau objectAtIndex:1];
        cell.lblGiaiSau3.text = [Sau objectAtIndex:2];
        
        
        cell.lblGiaiBay1.text = [Bay objectAtIndex:0];
        cell.lblGiaiBay2.text = [Bay objectAtIndex:1];
        cell.lblGiaiBay3.text = [Bay objectAtIndex:2];
        cell.lblGiaiBay4.text = [Bay objectAtIndex:3];
        
    } else {
        
        cell.lblGiaiNhi1.text = [Nhi objectAtIndex:0];
        
        
        cell.lblGiaiBa1.text = [Ba objectAtIndex:0];
        cell.lblGiaiBa2.text = [Ba objectAtIndex:1];
        
        
        cell.lblGiaiTu1.text = [Tu objectAtIndex:0];
        cell.lblGiaiTu2.text = [Tu objectAtIndex:1];
        cell.lblGiaiTu3.text = [Tu objectAtIndex:2];
        cell.lblGiaiTu4.text = [Tu objectAtIndex:3];
        cell.lblGiaiTu5.text = [Tu objectAtIndex:4];
        cell.lblGiaiTu6.text = [Tu objectAtIndex:5];
        cell.lblGiaiTu7.text = [Tu objectAtIndex:6];
        
        cell.lblGiaiNam1.text = [Nam objectAtIndex:0];
        
        
        cell.lblGiaiSau1.text = [Sau objectAtIndex:0];
        cell.lblGiaiSau2.text = [Sau objectAtIndex:1];
        cell.lblGiaiSau3.text = [Sau objectAtIndex:2];
        
        
        cell.lblGiaiBay1.text = [Bay objectAtIndex:0];
        
    }
    
    
    
    //tach du lieu
    //NSString* foo = @"safgafsfhsdhdfs/gfdgdsgsdg/gdfsgsdgsd";
    //NSArray* stringComponents = [foo componentsSeparatedByString:@"/"];
    
    
    // Configure the cell...
    cell.contentView.layer.cornerRadius = 5;
    [cell.contentView.layer setBorderColor:[UIColor redColor].CGColor];
    [cell.contentView.layer setBorderWidth:1.0f];
    
    return cell;
}

- (BOOL) KiemTraKetNoi {
    
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        //NSLog(@"There IS NO internet connection");
        return false;
        
    } else {
        //NSLog(@"There IS internet connection");
        return true;
    }
    
    
}

-(void) CapNhatKQXS {
    if ( [self KiemTraKetNoi] ) {
        
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        
        //    HUD.delegate = self;
        HUD.labelText = @"Đang cập nhật";
        
        // Set the hud to display with a color
        HUD.color = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
        
        [HUD show:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            /* Do some heavy work (you are now on a background queue) */
            
            [self hmtlParseFormKQXS];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                /* stop the activity indicator (you are now on the main queue again) */
                
                [HUD hide:YES];
                
                [self.tableview reloadData];
                
                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                
                HUD.mode = MBProgressHUDModeCustomView;
                
                HUD.labelText = @"Đã cập nhật";
                
                
                HUD.color = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.7];
                
                [HUD show:YES];
                [HUD hide:YES afterDelay:2];
                
            });
        });
        
    }
    else {
        alert = [[UIAlertView alloc] initWithTitle:@"Thông Báo"
                                           message:@"Không có kết nối Internet !!"
                                          delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
    }
}


@end
