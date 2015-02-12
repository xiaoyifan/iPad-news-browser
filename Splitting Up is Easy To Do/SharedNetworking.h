//
//  SharedNetworking.h
//  Splitting Up is Easy To Do
//
//  Created by XiaoYifan on 2/11/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedNetworking : NSObject

+(id)sharedSharedWorking;

-(void)getFeedForURL:(NSString*)url
             success:(void (^)(NSDictionary *dictionary, NSError *error))successCompletion
             failure:(void (^)(void))failureCompletion;

@end
