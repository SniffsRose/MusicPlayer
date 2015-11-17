//
//  NSError+Additions.m
//  KHealth
//
//  Created by wang hongxi on 13-10-31.
//  Copyright (c) 2013年 Beijing Dayactive CO. LTD. All rights reserved.
//

#import "NSError+Additions.h"

@implementation NSError(Additions)
-(BOOL)isURLError{
    return [self.domain isEqualToString:NSURLErrorDomain];
}
@end
