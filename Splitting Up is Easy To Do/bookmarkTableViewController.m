//
//  bookmarkTableViewController.m
//  Splitting Up is Easy To Do
//
//  Created by Alex Xiao on 2/13/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import "bookmarkTableViewController.h"

@interface bookmarkTableViewController ()<UIAlertViewDelegate>

@end

@implementation bookmarkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-toolbar buttons

- (IBAction)EditTable:(UIBarButtonItem *)sender {
    
    if ([self.tableView isEditing]) {
        self.tableView.editing = NO;
        sender.title = @"Edit";
    }
    else{
        self.tableView.editing = YES;
        sender.title = @"Done";
    }
    
}

- (IBAction)clearBookMark:(UIBarButtonItem *)sender {
    
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                          message:@"you are going to delete all bookmark records"
                                                         delegate:self
                                                cancelButtonTitle:@"Sure"
                                                otherButtonTitles:@"Never mind", nil];
    [deleteAlert show];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.ItemArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookmarkCell" forIndexPath:indexPath];
    
    NSDictionary* dictionary = [self.ItemArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dictionary objectForKey:@"title"];
    cell.detailTextLabel.text = [dictionary objectForKey:@"contentSnippet"];
    //load bookmark cell
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary* issue = [self.ItemArray objectAtIndex:indexPath.row];
    
    NSString* url = [issue objectForKey:@"link"];
    
    [self.delegate bookmark:self sendsURL:[NSURL URLWithString:url] andUpdateDictionaryItem: issue];
    //segue items back
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.ItemArray removeObjectAtIndex:indexPath.row];
        
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.ItemArray forKey:@"favoriteArray"];
        [defaults synchronize];
        //bookmark Edit
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UIAlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [self.ItemArray removeAllObjects];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.ItemArray forKey:@"favoriteArray"];
        [defaults synchronize];
        [self.tableView reloadData];
    }
}


@end
