//
//  DetailViewController.h
//  RSS_Reader
//
//  Created by XiaoYifan on 2/20/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

