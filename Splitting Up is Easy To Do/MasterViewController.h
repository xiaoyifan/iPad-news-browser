//
//  MasterViewController.h
//  Splitting Up is Easy To Do
//
//  Created by XiaoYifan on 2/10/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "Article.h"

@protocol spashScreenDelegate <NSObject>

-(void)displaySplashScreen:(id)sender;

-(void)dismissSplashScreen;

@end


@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) Article *issue;

@property (weak, nonatomic) id<spashScreenDelegate> delegate;



@end

