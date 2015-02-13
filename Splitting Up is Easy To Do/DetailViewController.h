//
//  DetailViewController.h
//  Splitting Up is Easy To Do
//
//  Created by XiaoYifan on 2/10/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

@property (strong, nonatomic) NSString *url;

@property (strong, nonatomic) NSDictionary *item;
//item is the dictionary of current page

@end

