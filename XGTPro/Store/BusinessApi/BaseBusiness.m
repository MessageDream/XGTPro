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

@interface BaseBusiness()
@property(nonatomic,strong) BaseHttpConnect * httpConnect;
@end

@implementation BaseBusiness

@synthesize businessErrorType = _businessErrorType;
@synthesize httpConnect = _httpConnect;
@synthesize errmsg = _errmsg;
@synthesize errCode = _errCode;

- (id)init{
    if (self = [super init]) {
        _httpConnect = [[JsonHttpConnect alloc] init];
    }
    return self;
}

- (void)execute:(NSDictionary *)theParm{
    if(theParm!=nil&&[self.httpConnect.resquestHeads.allValues count]==0)//可能有无参数的情况
    {
        if (![NSJSONSerialization isValidJSONObject:theParm])
            return;
    }
    
    if (_httpConnect) {
        _httpConnect.observer = self;
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
                _errCode=NO_ERROR;
            }else{
                _errCode = [[responseBodyDic objectForKey:@"status"] integerValue];
                if (_errCode==10||_errCode==1) {
                    _errCode=NO_ERROR;
                }
                _errmsg = [responseBodyDic objectForKey:@"error"];
            }
            if ([responseBodyDic objectForKey:@"result"]&&[[responseBodyDic objectForKey:@"result"] intValue]==0) {
                _errCode=REQUEST_UPDATE_ERROR;
            }
        }
    }
    switch (_errCode) {
        case USER_ERROR:
            self.businessErrorType = REQUEST_USER_ERROR;
            _errmsg=@"用户名不存在或密码错误";
            break;
        case NO_ERROR :
            self.businessErrorType = REQUEST_NOERROR;
            break;
        case  VERYCODE_ERROR :
            self.businessErrorType = REQUEST_VERYCODE_ERROR;
            _errmsg=@"验证码不正确";
            break;
        case  VERYCODE_NULL :
            self.businessErrorType = REQUEST_VERYCODE_NULL;
            _errmsg=@"验证码为空";
            break;
        case  VERYCODE_SEND_ERROR :
            self.businessErrorType = REQUEST_VERYCODE_SEND_ERROR;
            _errmsg=@"发送验证码失败";
            break;
        case  UPDATE_ERROR :
            self.businessErrorType = REQUEST_UPDATE_ERROR;
            _errmsg=@"更新失败";
            break;
        case  PARAM_ERROR :
            self.businessErrorType = REQUEST_PARAM_ERROR;
            _errmsg=@"请求参数或秘钥错误";
            break;
        case TIME_ERROR:
            self.businessErrorType = REQUEST_TIME_ERROR;
            break;
        case SYSTEM_ERROR:
            self.businessErrorType = REQUEST_SYSTEM_ERROR;
            break;
        case AUTH_ERROR:
            self.businessErrorType = REQUEST_AUTH_ERROR;
            break;
        default:
            break;
    }
}

- (BaseModel *)parseModelFromDic:(NSDictionary *)responseBodyDic{
    return nil;
}

- (void)handleBusinessError{
    if (self.businessObserver && [self.businessObserver respondsToSelector:@selector(didBusinessErrorWithCode:andMsg:)]){
        [self.businessObserver didBusinessErrorWithCode:_errCode andMsg:_errmsg];
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
    if (self.businessObserver && [self.businessObserver respondsToSelector:@selector(didBusinessFailWithCode:andMsg:)]){
        [self.businessObserver didBusinessFailWithCode:_errCode andMsg:_errmsg];
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
    if (self.businessObserver && [self.businessObserver respondsToSelector:@selector(didBusinessSuccessWithModel:)]){
        [self.businessObserver didBusinessSuccessWithModel:self.resultModel];
    }
}


-(void)dealloc{
    self.httpConnect.observer = nil;
}
@end
