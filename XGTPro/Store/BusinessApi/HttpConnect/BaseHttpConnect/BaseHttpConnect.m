//
//  BaseHttpConnect.m
//  HttpConnect
//
//  Created by Jayden Zhao on 13-3-31.
//  Copyright (c) 2013年 LightErector. All rights reserved.
//

#import "BaseHttpConnect.h"
#import "FormMltipart.h"
#import <AssetsLibrary/AssetsLibrary.h>

static NSOperationQueue *operationQueue = nil;
@interface BaseHttpConnect()
{
    
}
+(void)processFormMltipart:(id<AFMultipartFormData>)formData obj:(FormMltipart *)obj;
//解析返回数据
- (id)parseHttpConnectResponseData:(NSData *)data;
@end

@implementation BaseHttpConnect
@synthesize timeOut=_timeOut;
@synthesize respones = _respones;
@synthesize requestOperation = _requestOperation;
@synthesize resquestHeads = _resquestHeads;
@synthesize resquestType=_resquestType;
@synthesize baseUrl=_baseUrl;
@synthesize requestPath=_requestPath;
@synthesize body=_body;
@synthesize stauts = _stauts;
@synthesize errorCode = _errorCode;
@synthesize observer=_observer;

+(NSOperationQueue *)shareQueue{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        operationQueue =  [[NSOperationQueue alloc] init];
        [operationQueue setMaxConcurrentOperationCount:5];
    });
    
    return operationQueue;
}

- (id)init
{
    if (self = [super init]) {
        _resquestHeads = [[NSMutableDictionary alloc] init];
        _stauts = HttpContentStauts_WillStart;
        _errorCode = HttpErrorCode_None;
        _respones=[[HttpConnectRespones alloc] init];
        
        _operationQueue=[BaseHttpConnect shareQueue];
        
        __weak BaseHttpConnect *blockSelf = self;
        
        _success=^(AFHTTPRequestOperation *operation, id responseObject){
            
            blockSelf.stauts = HttpContentStauts_DidRespones;
            NSHTTPURLResponse * httpResponse;
            httpResponse = operation.response;
            blockSelf.errorCode = httpResponse.statusCode;
#ifdef DEBUG_LOG
            NSLog(@"the response status code is %ld\n",(long)httpResponse.statusCode);
#endif
            blockSelf.respones.responesHead = [httpResponse allHeaderFields];
            if(blockSelf.observer!=nil)
                [blockSelf.observer didGetHttpConnectResponseHead:blockSelf.respones.responesHead];
#ifdef DEBUG_LOG
            NSLog(@"the connection is %lu",(unsigned long)[operation.responseData length]);
#endif
            blockSelf.stauts = HttpContentStauts_DidFinishRespones;
            if (blockSelf.observer)
            {
                //需要加上业务错误对象判断的机制
                if(blockSelf.errorCode  != HttpErrorCode_None && [blockSelf.resquestType  isEqualToString:HTTP_REQUEST_POST])
                    [blockSelf.observer didHttpConnectError:blockSelf.errorCode];
                else
                {
                    blockSelf.respones.responesBody =  [blockSelf parseHttpConnectResponseData: blockSelf.requestOperation.responseData ];
                    [blockSelf.observer didHttpConnectFinish:blockSelf];
                }
            }
            [blockSelf closeConnect];
            
        };
        
        _failure=^(AFHTTPRequestOperation *operation, NSError *error){
            [blockSelf closeConnect];
            blockSelf.stauts = HttpContentStauts_DidStop;
            blockSelf.errorCode = error.code;
            if (blockSelf.observer) {
                [blockSelf.observer didHttpConnectError:blockSelf.errorCode];
            }
        };
    }
    return self;
}

-(void)send
{
    if (_stauts == HttpContentStauts_DidStart) {
        return;
    }
    
    if (_timeOut == 0) {
        _timeOut = CONNECT_DEFAULT_TIMEOUT;
    }
    
    if (_baseUrl==nil || _requestPath == nil) {
        return;
    }
    
    if (self.observer != nil) {
        [self.observer willHttpConnectRequest:self];
    }
    
    NSMutableURLRequest *request;
    if ([_resquestType isEqualToString:HTTP_REQUEST_POST]) {
        if ([[_resquestHeads objectForKey:HEADER_CONTENT_TYPE_NAME] isEqualToString:HEADER_CONTENT_TYPE_JSON_VALUE]) {
            request=[[AFJSONRequestSerializer serializer] requestWithMethod: _resquestType URLString:[_baseUrl stringByAppendingString:_requestPath] parameters:_body error:nil];
        }else{
            request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:_resquestType URLString:[_baseUrl stringByAppendingString:_requestPath] parameters:_body constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                id multipartParts =  [_body objectForKey:kFormMltipart];
                if (multipartParts) {
                    if ([multipartParts isKindOfClass:[NSArray class]]) {
                        for (FormMltipart *multipartPart in multipartParts) {
                            [BaseHttpConnect processFormMltipart:formData obj:multipartPart];
                        }
                    }else if ([multipartParts isKindOfClass:[FormMltipart class]]){
                        [BaseHttpConnect processFormMltipart:formData obj:multipartParts];
                    }
                }
                
              NSDictionary *dic=[_body objectForKey:@"ntspheader"];
                if (dic) {
                    NSError *error = nil;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
                    if (![jsonData length] && error){
                        return;
                    }
                    
                    FormMltipart *formheader=[[FormMltipart alloc] init];
                    formheader.formName=@"ntspheader";
                    formheader.type=FormMltipartTypeNormal;
                    formheader.data=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    [BaseHttpConnect processFormMltipart:formData obj:formheader];
 
                }
                
                [_body removeObjectForKey:kFormMltipart];
                
            } error:nil];
        }
        }else{
       request=[[AFJSONRequestSerializer serializer] requestWithMethod: _resquestType URLString:[_baseUrl stringByAppendingString:_requestPath] parameters:_body error:nil];
    }
    
    if (_resquestHeads != nil) {
        NSMutableDictionary *headdic=[NSMutableDictionary dictionaryWithDictionary:request.allHTTPHeaderFields ];
        int headCount=_resquestHeads.allValues.count;
            for (int index=0; index<headCount; index++)
                {
                    [headdic setValue:_resquestHeads.allValues[index] forKey:[_resquestHeads.allValues objectAtIndex:index]];
                    
                }
        [request setAllHTTPHeaderFields:headdic];
    }

    _stauts = HttpContentStauts_WillStart;
    
    [request setCachePolicy:kNetCachePolicy];
    [request setTimeoutInterval:_timeOut];
    
#ifdef DEBUG_LOG
    NSString *body = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    NSLog(@"send:%@\n httpHeader:%@\n httpBody:%@",self.requestPath,request.allHTTPHeaderFields, body);
#endif
    
    _requestOperation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [_requestOperation setCompletionBlockWithSuccess:_success failure:_failure];
    
    if (_downloadProcess!=nil) {
        [_requestOperation setDownloadProgressBlock:_downloadProcess];
    }
    if(_uploadProcess!=nil){
        [_requestOperation setUploadProgressBlock:_uploadProcess];
    }
    
    [_operationQueue addOperation:_requestOperation];
    
}

+(void)processFormMltipart:(id<AFMultipartFormData>)formData obj:(FormMltipart *)obj{
    switch (obj.type) {
            
        case FormMltipartTypeFilePath:
        {
            NSString *name = obj.formName;
            NSString *filename = obj.formFileName;
            NSString *mimeType = obj.formMimeType;
            id data = obj.data;
            NSURL  *fileurl = [NSURL fileURLWithPath:data];
            [formData appendPartWithFileURL:fileurl name:name fileName:filename mimeType:mimeType error:nil];
        }
            break;
            
        case FormMltipartTypeData:
        {
            NSString *name = obj.formName;
            NSString *filename = obj.formFileName;
            NSString *mimeType = obj.formMimeType;
            id data = obj.data;
            [formData appendPartWithFileData:data name:name fileName:filename mimeType:mimeType];
        }
            break;
        case FormMltipartTypeNormal:
        {
            NSString *name = obj.formName;
            id data = obj.data;
            if ([data isKindOfClass:[NSNumber class]]) {
                data = [data stringValue];
            }
            if ([data isKindOfClass:[NSString class]]) {
                [formData appendPartWithFormData:[data dataUsingEncoding:NSUTF8StringEncoding] name:name];
            }
            
        }
            break;
    }
}

- (void)closeConnect
{
#ifdef DEBUG_LOG
    NSLog(@"[client operationQueue]  -count - ----->%lu",(unsigned long)[[_operationQueue operations] count]);
    //[DebugManager LogDebug:@"[client operationQueue]  -count - ----->%i",[[[client operationQueue] operations] count]];
#endif
    if ([_requestOperation isCancelled]) {
        return;
    }
   // [_requestOperation cancel];
}



-(void)cancel
{
    [self closeConnect];
    _stauts = HttpContentStauts_DidStop;
}

- (id)parseHttpConnectResponseData:(NSData *)data{
    return data;
}

-(void)dealloc
{
    self.resquestType = nil;
    self.requestPath = nil;
    self.baseUrl=nil;
    _body = nil;
    _respones = nil;
    _requestOperation=nil;
    _resquestHeads = nil;
    _connection = nil;
    _success=nil;
    _observer=nil;
    _failure=nil;
    _downloadProcess=nil;
}
@end

