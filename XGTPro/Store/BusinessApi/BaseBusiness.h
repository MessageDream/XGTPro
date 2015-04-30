//
//  BaseBusiness.h
//  LightErector
//
//  Created by Jayden Zhao on 8/27/14.
//  Copyright (c) 2014 LightErector. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpConnectDelegate.h"
#import "BaseHttpConnect.h"
#import "BaseModel.h"
#import "BusinessProtocol.h"

@interface BaseBusiness : NSObject<HttpConnectDelegate,BusinessProtocol>
{
@protected
    NSInteger _errCode;
    NSString *_errmsg;
    BaseHttpConnect *_httpConnect;
}

@property(nonatomic,weak) id<BusinessDelegate>businessDelegate;
@property(nonatomic,strong)BaseModel *resultModel;
@property(nonatomic,readonly)NSString *errmsg;
@property(nonatomic,readonly)NSInteger errCode;


//获取错误码
- (void)errorCodeFromResponse:(NSDictionary *)responseBodyDic;

- (BaseModel *)parseModelFromDic:(NSDictionary *)responseBodyDic;

- (void)handleBusinessError;
@end

