//
//  FileSession.h
//  Splitting Up is Easy To Do
//
//  Created by XiaoYifan on 2/21/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileSession : NSObject


+(NSURL *)getListURL;

+(void)writeData:(id)object ToList:(NSURL*)url;

+(NSArray *)readDataFromList:(NSURL*)url;

@end
