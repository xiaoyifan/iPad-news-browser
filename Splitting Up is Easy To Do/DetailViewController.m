//
//  DetailViewController.m
//  Splitting Up is Easy To Do
//
//  Created by XiaoYifan on 2/10/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import "DetailViewController.h"
#import "bookmarkTableViewController.h"

@interface DetailViewController ()<UIWebViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *myWebVIew;
//the main webview of displaying web page

@property (strong, nonatomic) NSMutableArray *favoriteArray;
//items in the array will be loaded to BookmarkViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *favoriteButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *twitterButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *facebookButton;
//UIBarButtons' outlets


@end

@implementation DetailViewController

#pragma mark - Managing the detail item



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"The url is %@", self.url);
    
    if ([self.url isEqualToString:@"http://google.com"]) {
        self.favoriteButton.enabled = NO;
        self.twitterButton.enabled = NO;
        self.facebookButton.enabled = NO;
        //when the view is loaded at the first time, we choose google.com as the default page
        //and the default page can't be liked or shared
    }

    NSURL* nsUrl = [NSURL URLWithString:self.url];
    //get the url from segue
    
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    
     self.myWebView.delegate = self;
    [self.myWebView loadRequest:request];
    //load the URL request to WebView
    
    
    //if the favorite Array doesn't exist in NSUserDefault, we gotta initialize it.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults arrayForKey:@"favoriteArray"] == nil) {
        self.favoriteArray = [[NSMutableArray alloc]init];
        [defaults setObject:self.favoriteArray forKey:@"favoriteArray"];
        [defaults synchronize];
    }
    else{
        self.favoriteArray = [NSMutableArray arrayWithArray:[defaults arrayForKey:@"favoriteArray"]];
        //if the array exists, get the array from NSUserDefault and change it to NSMutableArray
    }
}


-(void)viewWillAppear:(BOOL)animated{
    self.myWebView.frame = self.view.frame;
    self.myWebView.scalesPageToFit = YES;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addFavorite:(UIBarButtonItem *)sender {
    
    NSInteger flag = 0;
    //flag is 0: the page is not in the bookmark list
    //flag is 1: the page is in the bookmark list
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //the favoriteArray is already synced with NSUserdefault
    for (int i=0; i<self.favoriteArray.count; i++) {
        NSString *title = [[self.favoriteArray objectAtIndex:i] objectForKey:@"title"];
        if ([title isEqualToString:[self.item objectForKey:@"title"]]) {
            flag =1;
            //use loop to detect is the page is already liked before
            break;
        }
    }
    
    if (flag == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Favorite" message:@"this page is already favorited, and you can check it out in bookmark" delegate:self cancelButtonTitle:@"got it" otherButtonTitles:nil, nil];
        
        [alert show];
        //UIAlertView to inform users that the page can't be liked again
    }
    else{
     
        [self.favoriteArray addObject:self.item];
        [defaults setObject:self.favoriteArray forKey:@"favoriteArray"];
        [defaults synchronize];
        //add the page info into bookmark
        //and sync to standardUserDefault
        
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liked it" message:@"you can check this page out from bookmark" delegate:self cancelButtonTitle:@"sure" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
    
    NSLog(@"favorite item is added");
    
}

#pragma mark-social network implementation

- (IBAction)TweetAboutIt:(UIBarButtonItem *)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twitterPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        NSString *text = [NSString stringWithFormat:@"great page: %@ ,check it out: %@",[self.item objectForKey:@"title"],[self.item objectForKey:@"link"]];
        [twitterPost setInitialText:text];
        [self presentViewController:twitterPost animated:YES completion:nil];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}

- (IBAction)facebookSharing:(UIBarButtonItem *)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *facebookPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        NSString *text = [NSString stringWithFormat:@"great page: %@ ,check it out: %@",[self.item objectForKey:@"title"],[self.item objectForKey:@"link"]];
        [facebookPost setInitialText:text];
        [self presentViewController:facebookPost animated:YES completion:nil];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a Facebook post right now, make sure your device has an internet connection and you have at least one Facebook account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}


#pragma mark - webView delegate implementation

//network indicator specification
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

}


#pragma mark - bookmark Delegate implementation

-(void)bookmark:(id)sender sendsURL:(NSURL *)url andUpdateDictionaryItem:(NSDictionary *)dic{
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:url]];
    self.item = dic;
}


#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showBookMark"]) {
        
        bookmarkTableViewController *bookmarkVC = (bookmarkTableViewController *)[[segue destinationViewController] topViewController];
        
        bookmarkVC.delegate = self;
        
        //segue the favorite Array to bookmarkViewController
        [bookmarkVC setItemArray:self.favoriteArray];
        
        
    }
    
}


@end
