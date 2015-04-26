//
//  BusinessManager.m
//  XGTPro
//
//  Created by Jayden Zhao on 15/4/15.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import "BusinessManager.h"
#import "BusinessProtocol+Rac.h"

@implementation BusinessManager
static NSMutableArray *businessPool;
static NSMutableDictionary *businessClassDic;
+(RACSignal *)excuteWithBusinessName:(NSString *)businessName andParameters:(NSDictionary *)param{
    return [self excuteWithBusinessName:businessName andDelegate:nil andParameters:param];
}

+(RACSignal *)excuteWithBusinessName:(NSString *)businessName  andDelegate:(id<BusinessDelegate>)delegate andParameters:(NSDictionary *)param{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        businessPool =  [[NSMutableArray alloc] init];
    });
    @weakify(delegate)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
         id<BusinessProtocol,BusinessRACProtocol> business = [self creatBusinessWithName:businessName];
        @strongify(delegate)
        if (business) {
            if ([business respondsToSelector:@selector(setDelegate:)]) {
                [business setDelegate:delegate];
            }
            [businessPool addObject:business];
            if ([business respondsToSelector:@selector(rac_isActiveSignal)]) {
                 RACSignal *businessSignal = [business rac_isActiveSignal];
                [businessSignal  subscribe:subscriber];
            }
            if ([business respondsToSelector:@selector(execute:)]) {
                 [business execute:param];
             }
            return [RACDisposable disposableWithBlock:^{
                [businessPool removeObject:business];
            }];
        }else{
            return nil;
        }
    }];
}

+(id<BusinessProtocol,BusinessRACProtocol>)creatBusinessWithName:(NSString *)name{
    
    static dispatch_once_t dicOnceToken;
    dispatch_once(&dicOnceToken, ^{
        businessClassDic =  [[NSMutableDictionary alloc] init];
    });
    
    Class cls = [businessClassDic objectForKey:name];
    if (cls) {
        return [[cls alloc] init];
    }else{
        cls = NSClassFromString(name);
        if (cls && [cls conformsToProtocol:@protocol(BusinessProtocol)] && [cls conformsToProtocol:@protocol(BusinessRACProtocol)]) {
            [businessClassDic setObject:cls forKey:name];
            return [[cls alloc] init];
        }else{
            return nil;
        }
    }
}
@end
