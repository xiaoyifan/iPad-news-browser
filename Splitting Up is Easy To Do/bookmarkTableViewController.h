//
//  bookmarkTableViewController.h
//  Splitting Up is Easy To Do
//
//  Created by Alex Xiao on 2/13/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol bookmarkToWebviewDelegate <NSObject>

-(void)bookmark:(id)sender sendsURL:(NSURL*)url;

@end



@interface bookmarkTableViewController : UITableViewController

@property (weak, nonatomic) id<bookmarkToWebviewDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *ItemArray;

@end
