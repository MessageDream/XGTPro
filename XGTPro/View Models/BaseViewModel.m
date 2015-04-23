//
//  BaseViewModel.m
//  LightErector
//
//  Created by Jayden Zhao on 8/27/14.
//  Copyright (c) 2014 LightErector. All rights reserved.
//

#import "BaseViewModel.h"
#import <ReactiveCocoa.h>
#import <objc/runtime.h>
#import "BusinessManager.h"

@interface BaseViewModel()
{
@protected
    NSError *_error;
}
@property(nonatomic,strong) NSError *error;
@end

@implementation BaseViewModel
- (RACSignal *)rac_isObserverActiveSignal{
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) return signal;
    @weakify(self)
    RACSignal *didBusinessFail = [[self rac_signalForSelector:@selector(didBusinessFailWithCode:andMsg:)  fromProtocol:@protocol(BusinessProtocol)] flattenMap:^RACStream *(id value) {
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            NSError * error = [self.error copy];
            [subscriber sendNext:error];
            [subscriber sendCompleted];
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];
    
    RACSignal *didBusinessError = [[self rac_signalForSelector:@selector(didBusinessErrorWithCode:andMsg:)
                                                  fromProtocol:@protocol(BusinessProtocol)] flattenMap:^RACStream *(id value) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            NSError * error = [self.error copy];
            [subscriber sendNext:error];
            [subscriber sendCompleted];
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];
    
    RACSignal *didBusinessSuccess = [[self rac_signalForSelector:@selector(didBusinessSuccessWithModel:)  fromProtocol:@protocol(BusinessProtocol)] flattenMap:^RACStream *(id value) {
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//            @strongify(self)
            [subscriber sendCompleted];
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];
    
    signal = [RACSignal merge:@[didBusinessFail,didBusinessError, didBusinessSuccess]];
    
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}

- (RACSignal *)creatBusinessWithName:(NSString *)businessName andExecuteWithData:(NSDictionary *)dic;{
    return [self creatBusinessWithName:businessName andObserver:self andExecuteWithData:dic];
}

- (RACSignal *)creatBusinessWithName:(NSString *)businessName andObserver:(id<BusinessProtocol>)observer andExecuteWithData:(NSDictionary *)dic{
    return  [BusinessManager excuteWithBusinessName:businessName andObserver:observer andParameters:dic];
}
#pragma mark - BusinessProtocol
- (void)didBusinessFailWithCode:(NSInteger)code andMsg:(NSString *)msg{
    self.error = [NSError errorWithDomain:NSStringFromSelector(_cmd) code:code userInfo:@{@(code):msg}];
}

- (void)didBusinessErrorWithCode:(NSInteger)code andMsg:(NSString *)msg{
    self.error = [NSError errorWithDomain:NSStringFromSelector(_cmd) code:code userInfo:@{@(code):msg}];
}

-(void)didBusinessSuccessWithModel:(BaseModel *)model{

}

-(void)dealloc
{
    if(baseBusiness!=nil)
    {
        baseBusiness.businessObserver = nil;
        [baseBusiness cancel];
    }
}
@end
