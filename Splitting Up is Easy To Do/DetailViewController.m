//
//  DetailViewController.m
//  Splitting Up is Easy To Do
//
//  Created by XiaoYifan on 2/10/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import "DetailViewController.h"
#import "bookmarkTableViewController.h"

@interface DetailViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *myWebVIew;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *favoriteButton;

@property (strong, nonatomic) NSMutableArray *favoriteArray;


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
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults arrayForKey:@"favoriteArray"] == nil) {
        self.favoriteArray = [[NSMutableArray alloc]init];
        [defaults setObject:self.favoriteArray forKey:@"favoriteArray"];
        [defaults synchronize];
    }
    else{
        self.favoriteArray = [NSMutableArray arrayWithArray:[defaults arrayForKey:@"favoriteArray"]];
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


-(void)webViewDidStartLoad:(UIWebView *)webView{
    self.myWebView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}


- (IBAction)addFavorite:(UIBarButtonItem *)sender {
    
    NSInteger flag = 0;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //the favoriteArray is already synced with NSUserdefault
    for (int i=0; i<self.favoriteArray.count; i++) {
        NSString *title = [[self.favoriteArray objectAtIndex:i] objectForKey:@"title"];
        if ([title isEqualToString:[self.item objectForKey:@"title"]]) {
            flag =1;
            break;
        }
    }
    //if the flag =1 , u can add this page to bookmark again.
    
    if (flag == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Favorite" message:@"this page is already favorited, and you can check it out in bookmark" delegate:self cancelButtonTitle:@"got it" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else{
     
        [self.favoriteArray addObject:self.item];
        [defaults setObject:self.favoriteArray forKey:@"favoriteArray"];
        [defaults synchronize];
        //add the page info into bookmark
        
    }
    
    NSLog(@"favorite item is added");
    
    
    //log out what we have in the NSUserDefaults
    for (int i=0; i<self.favoriteArray.count; i++) {
        NSLog(@"%@", [[self.favoriteArray objectAtIndex:i] objectForKey:@"title"]);
    }
}

#pragma mark - bookmark Delegate implementation

-(void)bookmark:(id)sender sendsURL:(NSURL *)url{
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
}


- (IBAction)TweetAboutIt:(UIBarButtonItem *)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twitterPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        NSString *text = [NSString stringWithFormat:@"I liked the article: %@ ,check it out: %@",[self.item objectForKey:@"title"],[self.item objectForKey:@"link"]];
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

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showBookMark"]) {
        
        bookmarkTableViewController *bookmarkVC = (bookmarkTableViewController *)[[segue destinationViewController] topViewController];
        
        bookmarkVC.delegate = self;
        
        [bookmarkVC setItemArray:self.favoriteArray];
        
        
    }
    
    
    
}


@end
