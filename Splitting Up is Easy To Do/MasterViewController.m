//
//  MasterViewController.m
//  Splitting Up is Easy To Do
//
//  Created by XiaoYifan on 2/10/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "SharedNetworking.h"
#import "MasterCell.h"

@interface MasterViewController ()

@property NSDictionary* links;

@property (nonatomic, strong) NSMutableArray *objects;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [self downloadDataFromWeb];
    
    
    UIRefreshControl *pullToRefresh = [[UIRefreshControl alloc] init];
    pullToRefresh.tintColor = [UIColor magentaColor];
    [pullToRefresh addTarget:self action:@selector(refreshAction)
            forControlEvents:UIControlEventValueChanged];
    self.refreshControl = pullToRefresh;
    
    
    NSString *url = @"http://google.com";
    
    [self.detailViewController setUrl:url];

}

-(void)downloadDataFromWeb{
    
    //download data from internet and put into self.objects
    [[SharedNetworking sharedSharedWorking]getFeedForURL:nil
                                                 success:^(NSDictionary *dictionary, NSError *error){
                                                     self.objects = dictionary[@"responseData"][@"feed"][@"entries"];
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [self.tableView reloadData];
                                                     });
                                                 }failure:^{
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         NSLog(@"Problem happened");
                                                     });
                                                     
                                                 }];
    
}

//table refreshing
- (void)refreshAction {
    NSLog(@"Pull To Refresh");
    // Do something with the table data
    
    [self downloadDataFromWeb];
    
    [self.tableView reloadData];
    // End the spinner on the table
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSDictionary * issueItem = [self.objects objectAtIndex:indexPath.row];
        //get the item tapped in the tableView
        
        NSString *link = [issueItem objectForKey:@"link"];
        [controller setUrl:link];
        //link is used to load the request
        
        [controller setItem:issueItem];
        //just used to be an dictionary item added into the bookmark
        
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MasterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterCell" forIndexPath:indexPath];

    self.issue = [self.objects objectAtIndex:indexPath.row];
    cell.itemTitle.text = [self.issue objectForKey:@"title"];
    cell.itemSnippet.text = [self.issue objectForKey:@"contentSnippet"];
    
    
    //Date Format specification
    NSDateFormatter *dateformat = [[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZZ"];
    NSDate *publishDate = [dateformat dateFromString:[self.issue objectForKey:@"publishedDate"]];
    
    [dateformat setDateFormat:@"MM-dd-yyyy"];
    NSString *date = [dateformat stringFromDate:publishDate];
    cell.itemDate.text = date;
    
    return cell;
}


@end
