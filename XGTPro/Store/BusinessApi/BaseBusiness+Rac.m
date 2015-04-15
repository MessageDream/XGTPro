//
//  BaseBusiness+Rac.m
//  XGTPro
//
//  Created by Jayden Zhao on 15/4/15.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import "BaseBusiness+Rac.h"
#import <RACEXTScope.h>
#import <objc/objc-runtime.h>
@implementation BaseBusiness (Rac)

- (RACSignal *)rac_isActiveSignal {
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) return signal;
    @weakify(self)
    RACSignal *didHttpConnectError = [[self rac_signalForSelector:@selector(didHttpConnectError:)
                                                 fromProtocol:@protocol(HttpConnectDelegate)] flattenMap:^RACStream *(id value) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            NSError *error = [NSError errorWithDomain:nil code:self.errCode userInfo:@{@"msg":self.errmsg}];
            [subscriber sendError:error];
            return [RACDisposable disposableWithBlock:nil];
        }];
    }];
        
    RACSignal *didHttpConnectFinish = [[self rac_signalForSelector:@selector(didHttpConnectFinish:)
                                                      fromProtocol:@protocol(HttpConnectDelegate)]  flattenMap:^RACStream *(id value) {
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            [subscriber sendNext:self.resultModel];
            [subscriber sendCompleted];
            return [RACDisposable disposableWithBlock:nil];
        }];
    }];
        
    signal = [RACSignal merge:@[didHttpConnectError, didHttpConnectFinish]];
    
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}
                                       
@end
