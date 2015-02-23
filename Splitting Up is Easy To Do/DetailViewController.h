//
//  DetailViewController.h
//  Splitting Up is Easy To Do
//
//  Created by XiaoYifan on 2/10/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bookmarkTableViewController.h"
#import "Social/Social.h"
#import "Article.h"

@protocol detailWebViewDelegate <NSObject>

-(void)webview:(id)sender IsLoaded:(BOOL)Value;


@end



@interface DetailViewController : UIViewController<bookmarkToWebviewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

@property (weak, nonatomic) id<detailWebViewDelegate> webDelegate;


//the link from MasterViewController
@property (strong, nonatomic) NSString *url;

//the dictionary item from MasterVC
@property (strong, nonatomic) Article *item;

@property (weak, nonatomic) IBOutlet UIImageView *favoriteStar;



@end

