//
//  BaseBusinessHttpConnect.m
//  G_NetLink
//
//  Created by Jayden Zhao on 14-3-20.
//  Copyright (c) 2014年 LightErector. All rights reserved.
//

#import "JsonHttpConnect.h"

@implementation JsonHttpConnect

- (void)createBaseBussinessHeads
{
    if (![_resquestHeads objectForKey:HEADER_CONTENT_TYPE_NAME]) {
        [_resquestHeads setObject:HEADER_CONTENT_TYPE_JSON_VALUE forKey:HEADER_CONTENT_TYPE_NAME];
    }
    //[_resquestHeads setObject:HEADER_CONTENT_LENGTH_VALUE forKey:HEADER_CONTENT_LENGTH_NAME];
}

//创建消息体
- (void)createBaseBussinessHttpBody:(NSDictionary *)theParam
{
    self.body=theParam;
    //    if (theParam!=nil) {
    //        if ([self.resquestType isEqualToString:HTTP_REQUEST_POST]) {
    //           self.body=theParam;
    //        }else if([self.resquestType isEqualToString:HTTP_REQUEST_GET]){
    //            [self setUrlParam:theParam];
    //        }
    //    }
}

-(void)setUrlParam:(NSDictionary *)theParam
{
    NSArray *pathcomp=[self.requestPath componentsSeparatedByString:@"?"];
    NSInteger count=theParam.allValues.count;
    NSString *path= self.requestPath;
    if (pathcomp.count>1) {
        for (int i=0; i<count; ++i) {
            if (i==0) {
                path=[path stringByAppendingString:@"&"];
            }
            path=  [path stringByAppendingFormat:@"%@=%@",[theParam.allKeys objectAtIndex:i],[theParam.allValues objectAtIndex:i]];
            if (i<count-1) {
                path=[path stringByAppendingString:@"&"];
            }
        }
    }else{
        path= [path stringByAppendingString:@"?"];
        for (int i=0; i<count; ++i) {
            path=  [path stringByAppendingFormat:@"%@=%@",[theParam.allKeys objectAtIndex:i],[theParam.allValues objectAtIndex:i]];
            if (i<count-1) {
                path=[path stringByAppendingString:@"&"];
            }
        }
        self.requestPath=path;
    }
}

- (id)parseHttpConnectResponseData:(NSData *)data{
    NSError * error;
    if (self.baseBusinessHttpConnect.respones.responesData) {
        return [NSJSONSerialization JSONObjectWithData:self.baseBusinessHttpConnect.respones.responesData options:NSJSONReadingMutableContainers error:&error];
    }else{
        return nil;
    }
}

- (void)sendWithParam:(NSDictionary *)theParam
{
    [self createBaseBussinessHeads];
    [self createBaseBussinessHttpBody:theParam];
    [super send];
}


@end
