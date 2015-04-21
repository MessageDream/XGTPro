//
//  BaseBusiness.h
//  LightErector
//
//  Created by Jayden Zhao on 8/27/14.
//  Copyright (c) 2014 LightErector. All rights reserved.
//

typedef NS_ENUM(NSInteger, BusinessErrorType)
{
    //    201	接口处理超时。
    //    202	必需的参数为空。
    //    203	系统错误。
    //    204	参数错误。
    //    8001	令牌失效

    REQUEST_USER_ERROR=0,
    REQUEST_NOERROR=1,
    REQUEST_VERYCODE_ERROR= 2, //验证码不正确
    REQUEST_VERYCODE_NULL =3, //验证码为空
    REQUEST_VERYCODE_SEND_ERROR= 4, //发送验证码失败
    REQUEST_UPDATE_ERROR =10, //更新失败
    
    REQUEST_TIME_ERROR=201,
    REQUEST_PARAMNULL_ERROR=202,
    REQUEST_SYSTEM_ERROR=203,
    
    REQUEST_PARAM_ERROR =403, //请求参数或秘钥错误
    
    REQUEST_AUTH_ERROR=8001,
    
};

#import <Foundation/Foundation.h>
#import "HttpConnectDelegate.h"
#import "BaseHttpConnect.h"
#import "HttpConnectDefineData.h"
#import "BaseModel.h"

@class BaseBusiness;

@protocol DownLoadBusinessProtocol <NSObject>
-(void)didDownLoadFileOfByteCount:(BaseBusiness *)business forByteCount:(long long)byteCount forTotalByteCount:(long long)totalByteCount;
@end

@protocol BusinessProtocol <NSObject>

- (void)didBusinessSucessWithModel:(BaseModel*)model;
- (void)didBusinessFail;
- (void)didBusinessErrorWithCode:(NSInteger)code andMsg:(NSString *)msg;
@end

@interface BaseBusiness : NSObject<HttpConnectDelegate>
{
@protected
    NSInteger _errCode;
    NSString *_errmsg;
    BusinessErrorType _businessErrorType;
    BaseHttpConnect *_httpConnect;
}

@property(nonatomic,weak) id<BusinessProtocol>businessObserver;
@property(nonatomic)BusinessErrorType businessErrorType;
@property(nonatomic,strong)BaseModel *resultModel;
@property(nonatomic,readonly)NSString *errmsg;
@property(nonatomic,readonly)NSInteger errCode;

//执行网络请求
- (void)execute:(NSDictionary *)param;

//取消请求
- (void)cancel;


//获取错误码
- (void)errorCodeFromResponse:(NSDictionary *)responseBodyDic;

- (BaseModel *)parseModelFromDic:(NSDictionary *)responseBodyDic;

- (void)handleBusinessError;
@end

