//
//  BusinessManager.m
//  XGTPro
//
//  Created by Jayden Zhao on 15/4/15.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import "BusinessManager.h"
#import "BaseBusiness+Rac.h"

@implementation BusinessManager
static NSMutableArray *businessPool;
static NSMutableDictionary *businessClassDic;
+(RACSignal *)excuteWithBusinessName:(NSString *)businessName andParameters:(NSDictionary *)param{
    return [self excuteWithBusinessName:businessName andObserver:nil andParameters:param];
}

+(RACSignal *)excuteWithBusinessName:(NSString *)businessName andObserver:(id<BusinessProtocol>)observer andParameters:(NSDictionary *)param{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        businessPool =  [[NSMutableArray alloc] init];
    });
    @weakify(observer)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        BaseBusiness *business = [self creatBusinessWithName:businessName];
        @strongify(observer)
        if (business) {
            business.businessObserver = observer;
            [businessPool addObject:business];
            RACSignal *businessSignal = business.rac_isActiveSignal;
            [businessSignal  subscribe:subscriber];
            [business execute:param];
            return [RACDisposable disposableWithBlock:^{
                [businessPool removeObject:business];
            }];
        }else{
            return nil;
        }
    }];
}

+(BaseBusiness *)creatBusinessWithName:(NSString *)name{
    
    static dispatch_once_t dicOnceToken;
    dispatch_once(&dicOnceToken, ^{
        businessClassDic =  [[NSMutableDictionary alloc] init];
    });
    
    Class cls = [businessClassDic objectForKey:name];
    if (cls) {
        return [[cls alloc] init];
    }else{
        cls = NSClassFromString(name);
        if (cls && [cls isSubclassOfClass:[BaseBusiness class]]) {
            [businessClassDic setObject:cls forKey:name];
            return [[cls alloc] init];
        }else{
            return nil;
        }
    }
}
@end
