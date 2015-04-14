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
#import "NtspHeader.h"

@implementation BaseBusiness
@synthesize businessId = _businessId;
@synthesize businessErrorType = _businessErrorType;
@synthesize baseBusinessHttpConnect = _baseBusinessHttpConnect;
@synthesize errmsg = _errmsg;
@synthesize errCode = _errCode;

- (id)init
{
    if (self = [super init]) {
        self.httpConnect = [[JsonHttpConnect alloc] init];
    }
    return self;
}

- (void)execute:(NSDictionary *)theParm
{
    if(theParm!=nil&&[self.baseBusinessHttpConnect.resquestHeads.allValues count]==0)//可能有无参数的情况
    {
        if (![NSJSONSerialization isValidJSONObject:theParm])
            return;
    }
    
    if (self.httpConnect) {
        self.httpConnect.observer = self;
        [self.httpConnect sendWithParam:theParm];
    }
}

- (void)cancel
{
    if (self.httpConnect) {
        [self.httpConnect cancel];
    }
}



//获取错误码
- (void)errorCodeFromResponse:(NSDictionary *)theResponseBody
{
    if (theResponseBody) {
        if ([theResponseBody isKindOfClass:[NSDictionary class]]) {
            //附加部分，具体根据接口判断
            if (![theResponseBody objectForKey:@"status"]) {
                _errCode=NO_ERROR;
            }else{
                _errCode = [[theResponseBody objectForKey:@"status"] integerValue];
                if (_errCode==10||_errCode==1) {
                    _errCode=NO_ERROR;
                }
                _errmsg = [theResponseBody objectForKey:@"error"];
            }
            if ([theResponseBody objectForKey:@"result"]&&[[theResponseBody objectForKey:@"result"] intValue]==0) {
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

-(void) willHttpConnectRequest:(BaseHttpConnect*)httpContent
{
   
}

-(void) httpConnectResponse:(BaseHttpConnect*)httpContent GetByteCount:(NSInteger)byteCount
{
}

-(void)didGetHttpConnectResponseHead:(NSDictionary*)allHead
{
    
}

-(void)httpConnectResponse:(BaseHttpConnect *)httpContent getByteCount:(NSInteger)byteCount
{
    
}

-(void)httpConnectResponse:(BaseHttpConnect *)httpContent uploadByteCount:(NSInteger)byteCount
{
    
}

-(void) didHttpConnectError:(enum HttpErrorCode)errorCode
{
    if (self.businessObserver)
    {
        _errmsg = [HttpErrorCodeManager getDesFromErrorCode:errorCode];
        [self.businessObserver didBusinessError:self];
    }
}

-(void) didHttpConnectFinish:(BaseHttpConnect *)httpContent
{
    NSDictionary * responseBodyDic = httpContent.respones.responseBody;
    
#ifdef DEBUG_LOG
    NSLog(@"rece:%@",responseBodyDic);
#endif
    if (responseBodyDic) {
        [self errorCodeFromResponse:responseBodyDic];
        if(_errCode != REQUEST_NOERROR){
            [self.businessObserver didBusinessError:self];
            return;
        }
    }
    [self.businessObserver didBusinessSucess:self withData:responseBodyDic];
}


-(void)dealloc
{
    self.baseBusinessHttpConnect.observer = nil;
}
@end
