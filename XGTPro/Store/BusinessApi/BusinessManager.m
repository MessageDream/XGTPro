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
+(RACSignal *)creatBusiness{
   
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        BaseBusiness *business = [[BaseBusiness alloc] init];
        [businessPool addObject:business];
        RACSignal *businessSignal = business.rac_isActiveSignal;
        [businessSignal  subscribe:subscriber];
        return [RACDisposable disposableWithBlock:^{
            [businessPool removeObject:business];
        }];
    }];
}
@end
