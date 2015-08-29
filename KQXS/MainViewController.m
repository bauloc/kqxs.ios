
//
//  MainViewController.m
//  KQXS
//
//  Created by MAC on 6/23/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"

#import "kqxsCellMienNam.h"

#import "HTMLParser.h"

#import "VeSo.h"

#import "Reachability.h"

#import "AppDelegate.h"

#import "MBProgressHUD.h"


static NSMutableArray *lstVeSoMienTrung;
static NSMutableArray *lstVeSoMienNam;
static NSMutableArray *lstVeSoMienBac;

int biendungchung = 1000;
static int t = 0;

UIAlertView *alert;
UIRefreshControl *refreshControl;


UIActivityIndicatorView *indicator;

SWRevealViewController *revealViewController;

MBProgressHUD *HUD;


@interface MainViewController () {


}



@end

@implementation MainViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) stopIndicator {
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.labelText = @"Đã cập nhật";
    

    HUD.color = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.7];
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:2];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Cach 1
//    if (t == 0) {
//        t = 1;
//        [self khoidong1lan];
//    }
    
    // Cach 2
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self khoidong1lan];
//    });
    

    
    // Hiển thị phần menu
    
    self.title = @"Kết  Quả  Hiện  Tại";
    
    revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [sidebarButton setTarget: self.revealViewController];
        [sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    // Xoá đường viền giữa các cell trong TableView
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    khởi tạo các biến
    
    mienTrung =  @"Kon Tum - Khánh Hòa - Phú Yên - Thừa Thiên Huế - Đack Lac - Quảng Nam - Đà Nẳng - Bình Định - Quảng Bình - Quảng Trị - Gia Lai - Ninh Thuận - Đắc Nông - Quảng Ngãi" ;

    
//    khởi tạo indicator
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    indicator.frame = CGRectMake(0.0, 0.0, 50.0, 50.0);
    
    indicator.layer.cornerRadius = 5;
    indicator.layer.masksToBounds = YES;
    
    indicator.backgroundColor = [UIColor colorWithWhite:1 alpha:0.95];
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];

//    Đoạn chương trình này chỉ được gọi một lần
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self CapNhatKQXS];
        });
    
    
//  Tạo giao diện kéo - thả để update dữ liệu kết quả xổ số trên TableView
    /*

    // Create the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    refreshControl = [[UIRefreshControl alloc]init];
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"cập nhật dữ liệu ..."
    attributes: @{NSForegroundColorAttributeName:[UIColor colorWithRed:(255/255.0) green:(00/255.0) blue:(102/255.0) alpha:1]}];
    
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithAttributedString:title];
    
    [tableView addSubview:refreshControl];
    
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
  
     */

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) hmtlParseFormKQXS
{
    NSLog(@"cap nhat KQXS");
    
    NSError *error = nil;
    
    
    NSURL *kqxs= [NSURL URLWithString:@"http://www.kqxs.vn/"];

    
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
                [lstVeSoMienNam addObject:veSo];

            } else {
                veSo.mien = @"MIENTRUNG";
                veSo.ngayMoThuong = ngayMienTrung;
                [lstVeSoMienTrung addObject:veSo];
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
            
            [lstVeSoMienBac addObject:veSo];
        }
        
        
        
    }
    
   // HTMLNode *daiMoThuong = [dsBaMien objectAtIndex:0];
    

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    switch (segment.selectedSegmentIndex) {
        case 0:
            return [lstVeSoMienNam count];
            break;
        case 1:
            return [lstVeSoMienTrung count];
            break;
        case 2:
            return [lstVeSoMienBac count];
            break;
        default:
            return  1;
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *simpleTableIdentifier = @"CellMienNam";
    NSArray *nib;
    switch (segment.selectedSegmentIndex) {
        case 0:
            simpleTableIdentifier = @"CellMienNam";
            break;
        case 1:
            simpleTableIdentifier = @"CellMienNam";
            break;
        case 2:
            simpleTableIdentifier = @"CellMienBac";
            break;
        default:
            break;
    }
    
    kqxsCellMienNam *cell = (kqxsCellMienNam *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        switch (segment.selectedSegmentIndex) {
            case 0:
                nib = [[NSBundle mainBundle] loadNibNamed:@"kqxsCellMienNam" owner:self options:nil];
                break;
            case 1:
                nib = [[NSBundle mainBundle] loadNibNamed:@"kqxsCellMienNam" owner:self options:nil];
                break;
            case 2:
                nib = [[NSBundle mainBundle] loadNibNamed:@"kqxsCellMienBac" owner:self options:nil];
                break;
            default:
                break;
        }
        
        //NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"kqxsCellMienNam" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    VeSo *veSo ;
    
    switch (segment.selectedSegmentIndex) {
        case 0:
            veSo = [lstVeSoMienNam objectAtIndex:indexPath.section];
            break;
        case 1:
            veSo = [lstVeSoMienTrung objectAtIndex:indexPath.section];
            break;
        case 2:
            veSo = [lstVeSoMienBac objectAtIndex:indexPath.section];
            break;
        default:
            break;
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.; // you can have your own choice, of course
}


- (IBAction)DoiMienXoSo:(UISegmentedControl *)sender {
    [tableView reloadData];
}

- (IBAction)CapNhatKetQua:(UIBarButtonItem *)sender {
    
    [self CapNhatKQXS];

    
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    responseData = [[NSMutableData alloc] init];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    
//    NSLog(@"Loi ket noi: %d",code);
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
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
        
        lstVeSoMienNam = [[NSMutableArray alloc] init];
        lstVeSoMienTrung = [[NSMutableArray alloc] init];
        lstVeSoMienBac = [[NSMutableArray alloc] init];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            /* Do some heavy work (you are now on a background queue) */
            
            [self hmtlParseFormKQXS];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                /* stop the activity indicator (you are now on the main queue again) */

                [HUD hide:YES];
                
                [tableView reloadData];
                
                [self stopIndicator];
                
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
