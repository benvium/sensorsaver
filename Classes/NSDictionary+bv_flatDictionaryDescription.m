//
//  NSDictionary+bv_flatDictionaryDescription.m
//  LocationRecorder
//
//  Created by Benjamin Clayton on 29/11/2012.
//  Copyright (c) 2012 Calvium Ltd. All rights reserved.
//

#import "NSDictionary+bv_flatDictionaryDescription.h"

@implementation NSDictionary (bv_flatDictionaryDescription)


-(NSString*) bv_flatDictionaryDescription {
    NSMutableString* str = [[NSMutableString alloc] initWithCapacity:5];
    NSArray* allKeys = self.allKeys;

    for (int i = 0; i < [allKeys count]; i ++) {
        NSString*key = allKeys[i];
        [str appendFormat:@"\"%@\":%@,", key, self[key]];
    }

    return str;
}

@end
