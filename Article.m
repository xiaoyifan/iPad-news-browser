//
//  Article.m
//  Splitting Up is Easy To Do
//
//  Created by XiaoYifan on 2/20/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import "Article.h"

@implementation Article

- (void)encodeWithCoder:(NSCoder *)encoder {
    //[super encodeWithCoder: encoder]; // if super conforms to NSCoding
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.publishedDate forKey:@"publishedDate"];
    [encoder encodeObject:self.contentSnippet forKey:@"contentSnippet"];
    [encoder encodeObject:self.link forKey:@"link"];
}
- (id) initWithCoder:(NSCoder *)decoder {
    //self = [super initWithCoder: decoder]; // if super conforms to NSCoding
    self = [super init];
    self.title = [decoder decodeObjectForKey:@"title"];
    self.contentSnippet = [decoder decodeObjectForKey:@"contentSnippet"];
    self.publishedDate = [decoder decodeObjectForKey:@"publishedDate"];
    self.link = [decoder decodeObjectForKey:@"link"];

    return self;
}

@end
