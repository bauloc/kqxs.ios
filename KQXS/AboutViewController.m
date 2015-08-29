//
//  AboutViewController.m
//  KQXS
//
//  Created by MAC on 6/30/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "AboutViewController.h"
#import "SWRevealViewController.h"
#import "ETFoursquareImages.h"

extern int biendungchung;

@interface AboutViewController ()

@end

@implementation AboutViewController

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
	// Do any additional setup after loading the view.
    
    NSLog(@"=====> ABCDE: %d", biendungchung);
    
    self.title = @"Thông Tin";
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [sidebarButton setTarget: self.revealViewController];
        [sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    int imagesHeight = 250;

    int navihieght  = self.navigationController.navigationBar.frame.size.height;
    
    ETFoursquareImages *foursquareImages = [[ETFoursquareImages alloc] initWithFrame:CGRectMake(0, 20+ navihieght, 320, self.view.frame.size.height)];
    
    [foursquareImages setImagesHeight:imagesHeight];
    
    NSArray *images  = @[ [UIImage imageNamed:@"than_tai"], [UIImage imageNamed:@"cot_dien_1"], [UIImage imageNamed:@"cot_dien_2"] , [UIImage imageNamed:@"cot_dien_3"]];
    
    [foursquareImages setImages:images];
    
    [self.view addSubview:foursquareImages];
    
    UITextView *hintTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, imagesHeight, 320, 110)];
    hintTextView.userInteractionEnabled = NO;
    hintTextView.text = @"Xổ Số Ba Miền";
    hintTextView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
    
    //[foursquareImages.scrollView addSubview:hintTextView];
    
    UITextView *textview = [[UITextView alloc] initWithFrame:CGRectMake(0, imagesHeight, 320, 90)];
    textview.userInteractionEnabled = NO;
    textview.text = @"Ứng dụng Xổ Số Ba Miền (v1.0) được thiết kế giúp bạn tiết kiệm thời gian, lưu lượng và nhận được kết quả nhanh và chính xác nhất. \n\n© 2015 - Kỹ sư Nguyễn Phước Lộc ";
    
    textview.font = [UIFont fontWithName:@"Souvenir" size:15.0];
    textview.textAlignment = NSTextAlignmentCenter;
    
    [foursquareImages.scrollView addSubview:textview];
    
    
    UIWebView *textview1 = [[UIWebView alloc] initWithFrame:CGRectMake(15, imagesHeight + textview.frame.size.height, 320, 100)];
    
    textview1.dataDetectorTypes = UIDataDetectorTypeAll; //or UIDataDetectorTypeAddress etc..

    
    NSString *html = @"Skype: loc.plsoft </br>Phone: +841649520631 </br>Email: loc.plsoft@gmail.com";
    
    [textview1 loadHTMLString:html baseURL:nil];

    
//    textview1.font = [UIFont fontWithName:@"Souvenir" size:15.0];
//    textview1.textAlignment = NSTextAlignmentCenter;
    
    [foursquareImages.scrollView addSubview:textview1];
    
    foursquareImages.scrollView.contentSize = CGSizeMake(320, 110+imagesHeight);
    
    [foursquareImages.pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithRed:(28/255.f) green:(189/255.f) blue:(141/255.f) alpha:1.0]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
