//
//  DetailViewController.m
//  Splitting Up is Easy To Do
//
//  Created by XiaoYifan on 2/10/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *myWebVIew;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *favoriteButton;


@end

@implementation DetailViewController

#pragma mark - Managing the detail item



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"The url is %@", self.url);
    
    if ([self.url isEqualToString:@"http://google.com"]) {
        self.favoriteButton.enabled = NO;
    }
    //if the page we load is the default one, we gotta disable the like button, cuz the default page cannot be liked.
    
    NSURL* nsUrl = [NSURL URLWithString:self.url];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    
    [self.myWebView loadRequest:request];
    self.myWebView.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    self.myWebView.frame = self.view.frame;
    self.myWebView.scalesPageToFit = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    self.myWebView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}



@end
