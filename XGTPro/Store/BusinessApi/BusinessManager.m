//
//  BusinessManager.m
//  XGTPro
//
//  Created by Jayden Zhao on 15/4/15.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import "BusinessManager.h"
#import "BaseBusiness.h"
#import "BaseBusiness+Rac.h"

@implementation BusinessManager
static NSMutableArray *businessPool;
static NSMutableDictionary *businessClassDic;
+(RACSignal *)excuteWithBusinessName:(NSString *)businessName andParameters:(NSDictionary *)param{
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        businessPool =  [[NSMutableArray alloc] init];
    });

    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        BaseBusiness *business = [self creatBusinessWithName:businessName];
        if (business) {
            [businessPool addObject:business];
            RACSignal *businessSignal = business.rac_isActiveSignal;
            [businessSignal  subscribe:subscriber];
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
