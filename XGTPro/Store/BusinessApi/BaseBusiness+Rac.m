//
//  BaseBusiness+Rac.m
//  XGTPro
//
//  Created by Jayden Zhao on 15/4/15.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import "BaseBusiness+Rac.h"
#import <RACEXTScope.h>
#import <objc/runtime.h>

@implementation BaseBusiness (Rac)

- (RACSignal *)rac_isActiveSignal {
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) return signal;
    @weakify(self)
    RACSignal *didHttpConnectError = [[self rac_signalForSelector:@selector(didHttpConnectError:)
                                                 fromProtocol:@protocol(HttpConnectDelegate)] flattenMap:^RACStream *(id value) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            NSError *error = [NSError errorWithDomain:NSStringFromSelector(_cmd) code:self.errCode userInfo:@{@(self.errCode):self.errmsg}];
            [subscriber sendError:error];
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];
    
    RACSignal *didHttpConnectHandleBusinessError = [[self rac_signalForSelector:@selector(handleBusinessError)] flattenMap:^RACStream *(id value) {
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            NSError *error = [NSError errorWithDomain:NSStringFromSelector(_cmd) code:self.errCode userInfo:@{@(self.errCode):self.errmsg}];
            [subscriber sendError:error];
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];
    
    RACSignal *didHttpConnectParseModel = [[self rac_signalForSelector:@selector(parseModelFromDic:)] flattenMap:^RACStream *(id value) {
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            [subscriber sendNext:self.resultModel];
            [subscriber sendCompleted];
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];
        
    signal = [RACSignal merge:@[didHttpConnectError,didHttpConnectHandleBusinessError, didHttpConnectParseModel]];
    
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}
@end
