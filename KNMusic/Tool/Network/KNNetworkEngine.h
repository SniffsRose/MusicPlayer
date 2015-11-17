//
//  KNNetworkEngine.h
//  KNMusic
//
//  Created by KN on 15/9/7.
//  Copyright © 2015年 KN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkEngine.h"


@interface KHError : NSError
@property (nonatomic,copy) NSString *reason;
-(id)initWithMKNetworkOperation:(MKNetworkOperation *)op error:(NSError *)error;
@end

@interface KNNetworkEngine : MKNetworkEngine


typedef void (^CommonResponseBlock)(BOOL changed);
typedef void (^ListResponseBlock)(NSMutableArray *array);
//typedef void (^ProList)

@property (nonatomic,assign) BOOL showError;
-(void)showPrompt:(NSString *)msg;
-(BOOL)checkError:(id)resp;

@end
