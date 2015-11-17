//
//  KNNetworkEngine.m
//  KNMusic
//
//  Created by KN on 15/9/7.
//  Copyright © 2015年 KN. All rights reserved.
//

#import "KNNetworkEngine.h"
#define kServerBase @"tingapi.ting.baidu.com"
#define kAppErrorDomain @"应用错误"
#define kErrorParse @"解析数据出错"
@implementation KHError
-(NSString *)localizedFailureReason{
    if (_reason) {
        return _reason;
    }
    if ([self.domain isEqualToString:NSURLErrorDomain]) {
        return @"网络错误";
    }
    return [self localizedDescription];
}
-(id)initWithMKNetworkOperation:(MKNetworkOperation *)op error:(NSError *)error{
    NSInteger statusCode = op.HTTPStatusCode;
    id respJson = op.responseJSON;
    if ([respJson isKindOfClass:[NSDictionary class]] || [respJson isKindOfClass:[NSArray class]]) {
        self = [self initWithDomain:kAppErrorDomain code:statusCode userInfo:nil];
        if ([respJson isKindOfClass:[NSArray class]]) {
            NSMutableString *string = [NSMutableString string];
            NSInteger idx = 0;
            for (NSDictionary *dict in respJson) {
                if (idx == 0) {
                    [string appendString:[dict objectForKey:@"message"]];
                }
                else{
                    [string appendFormat:@"\n%@",[dict objectForKey:@"message"]];
                }
            }
            self.reason = string;
        }
        else{
            self.reason = [respJson objectForKey:@"message"];
        }
    }
    else{
        self = [self initWithDomain:error.domain code:error.code userInfo:error.userInfo];
        self.reason = [error localizedFailureReason];
    }
    return self;
}
@end

@implementation KNNetworkEngine

-(BOOL) isCacheable{
    return NO;
}
-(id)init
{
    self = [self initWithHostName:kServerBase];
    if (self) {
        //        self.portNumber = 8100;
    }
    return self;
}

-(MKNetworkOperation*) operationWithPath:(NSString*) path {
    
    MKNetworkOperation *op = [super operationWithPath:path];
    op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
    op.stringEncoding = NSUTF8StringEncoding;
    
    return op;
}

-(MKNetworkOperation*) operationWithPath:(NSString*) path
                                  params:(NSDictionary*) body {
    MKNetworkOperation *op = [super operationWithPath:path params:body];
    op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
    op.stringEncoding = NSUTF8StringEncoding;
    return op;
}

-(MKNetworkOperation*) operationWithPath:(NSString*) path
                                  params:(NSDictionary*) body
                              httpMethod:(NSString*)method  {
    
    MKNetworkOperation *op = [super operationWithPath:path params:body httpMethod:method];
    op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
    op.stringEncoding = NSUTF8StringEncoding;
    return op;
}

-(void)showPrompt:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
-(BOOL)checkError:(id)resp{
    if ([resp isKindOfClass:[NSDictionary class]]) {
        NSString *msg = [resp objectForKey:@"message"];
        if (msg && [msg isKindOfClass:[NSString class]] && msg.length > 0) {
            if (_showError) {
                [self showPrompt:msg];
            }
            return YES;
        }
    }
    return NO;
}


@end
