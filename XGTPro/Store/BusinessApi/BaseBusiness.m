//
//  BaseBusiness.m
//  LightErector
//
//  Created by Jayden Zhao on 8/27/14.
//  Copyright (c) 2014 LightErector. All rights reserved.
//

#import "BaseBusiness.h"
#import "JsonHttpConnect.h"
#import "HttpErrorCodeManager.h"

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

@interface BaseBusiness()
@property(nonatomic,strong) BaseHttpConnect * httpConnect;
@end

@implementation BaseBusiness
@synthesize httpConnect = _httpConnect;
@synthesize errmsg = _errmsg;
@synthesize errCode = _errCode;

- (id)init{
    if (self = [super init]) {
        _httpConnect = [[JsonHttpConnect alloc] init];
    }
    return self;
}

-(void)setDelegate:(id<BusinessDelegate>)delegate{
    self.businessDelegate = delegate;
}

- (void)execute:(NSDictionary *)theParm{
    if(theParm!=nil){//可能有无参数的情况
        if (![NSJSONSerialization isValidJSONObject:theParm])
            return;
    }
    
    if (_httpConnect) {
        _httpConnect.delegate = self;
        [_httpConnect sendWithParam:theParm];
    }
}

- (void)cancel{
    if (_httpConnect) {
        [_httpConnect cancel];
    }
}

//获取错误码
- (void)errorCodeFromResponse:(NSDictionary *)responseBodyDic{
    if (responseBodyDic) {
        if ([responseBodyDic isKindOfClass:[NSDictionary class]]) {
            //附加部分，具体根据接口判断
            if (![responseBodyDic objectForKey:@"status"]) {
                _errCode=REQUEST_NOERROR;
            }else{
                _errCode = [[responseBodyDic objectForKey:@"status"] integerValue];
                if (_errCode==10||_errCode==1) {
                    _errCode=REQUEST_NOERROR;
                }
                _errmsg = [responseBodyDic objectForKey:@"error"];
            }
            if ([responseBodyDic objectForKey:@"result"]&&[[responseBodyDic objectForKey:@"result"] intValue]==0) {
                _errCode=REQUEST_UPDATE_ERROR;
            }
        }
    }
    switch (_errCode) {
        case REQUEST_USER_ERROR:
            _errmsg=@"用户名不存在或密码错误";
            break;
        case REQUEST_NOERROR :
            break;
        case  REQUEST_VERYCODE_ERROR :
            _errmsg=@"验证码不正确";
            break;
        case  REQUEST_VERYCODE_NULL :
            _errmsg=@"验证码为空";
            break;
        case  REQUEST_VERYCODE_SEND_ERROR :
            _errmsg=@"发送验证码失败";
            break;
        case  REQUEST_UPDATE_ERROR :
            _errmsg=@"更新失败";
            break;
        case  REQUEST_PARAM_ERROR :
            _errmsg=@"请求参数或秘钥错误";
            break;
        case REQUEST_TIME_ERROR:
            break;
        case REQUEST_SYSTEM_ERROR:
            break;
        case REQUEST_AUTH_ERROR:
            break;
        default:
            break;
    }
}

- (BaseModel *)parseModelFromDic:(NSDictionary *)responseBodyDic{
    return nil;
}

- (void)handleBusinessError{
    if (self.businessDelegate && [self.businessDelegate respondsToSelector:@selector(didBusinessErrorWithCode:andMsg:)]){
        [self.businessDelegate didBusinessErrorWithCode:_errCode andMsg:_errmsg];
    }
}

-(void) willHttpConnectRequest:(BaseHttpConnect*)httpContent{
   
}

-(void) httpConnectResponse:(BaseHttpConnect*)httpContent GetByteCount:(NSInteger)byteCount{
    
}

-(void)didGetHttpConnectResponseHead:(NSDictionary*)allHead{
    
}

-(void)httpConnectResponse:(BaseHttpConnect *)httpContent getByteCount:(NSInteger)byteCount{
    
}

-(void)httpConnectResponse:(BaseHttpConnect *)httpContent uploadByteCount:(NSInteger)byteCount{
    
}

-(void) didHttpConnectError:(enum HttpErrorCode)errorCode{
    _errCode = errorCode;
    _errmsg = [HttpErrorCodeManager getDesFromErrorCode:errorCode];
    if (self.businessDelegate && [self.businessDelegate respondsToSelector:@selector(didBusinessFailWithCode:andMsg:)]){
        [self.businessDelegate didBusinessFailWithCode:_errCode andMsg:_errmsg];
    }
}

-(void) didHttpConnectFinish:(BaseHttpConnect *)httpContent{
    NSDictionary * responseBodyDic = httpContent.respones.responesBody;
    
#ifdef DEBUG_LOG
    NSLog(@"rece:%@",responseBodyDic);
#endif
    if (responseBodyDic) {
        [self errorCodeFromResponse:responseBodyDic];
        if(_errCode != REQUEST_NOERROR){
            [self handleBusinessError];
            return;
        }
       self.resultModel = [self parseModelFromDic:responseBodyDic];
    }
    if (self.businessDelegate && [self.businessDelegate respondsToSelector:@selector(didBusinessSuccessWithModel:)]){
        [self.businessDelegate didBusinessSuccessWithModel:self.resultModel];
    }
}

-(void)dealloc{
    self.httpConnect.delegate = nil;
}
@end
