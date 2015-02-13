//
//  SharedNetworking.m
//  Splitting Up is Easy To Do
//
//  Created by XiaoYifan on 2/11/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import "SharedNetworking.h"

@implementation SharedNetworking

+(id)sharedSharedWorking{
 
    static dispatch_once_t pred;
    static SharedNetworking *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[self alloc]init];
    });
    return shared;
}

-(void)getFeedForURL:(NSString*)url
             success:(void (^)(NSDictionary *dictionary, NSError *error))successCompletion
             failure:(void (^)(void))failureCompletion{
    
    // Google News API url
    NSString *googleUrl = @"http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=30&q=http%3A%2F%2Fnews.google.com%2Fnews%3Foutput%3Drss";
    
    // Create NSUrlSession
    NSURLSession *session = [NSURLSession sharedSession];
    
    // Create data download taks
    [[session dataTaskWithURL:[NSURL URLWithString:googleUrl]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                NSLog(@"Response:%@", response);
                        
                NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                
                if (httpResp.statusCode == 200) {
                    NSError *jsonError;
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                               options:NSJSONReadingAllowFragments
                                                                                 error:&jsonError];
                    NSLog(@"Downloaded Data: %@", dictionary);
                    
                    successCompletion(dictionary, nil);
                }
                else{
                    
                    NSLog(@"Fail not 200:");
                    // Use dispatch_async to update the table on the main thread
                    // Remember that NSURLSession is downloading in the background
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (failureCompletion) {
                            failureCompletion();
                        }
                        //code to end the refreshing operation
                    });
                }
                
            }] resume];
}

@end
