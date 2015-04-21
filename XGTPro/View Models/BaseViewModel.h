//
//  BaseViewModel.h
//  LightErector
//
//  Created by Jayden Zhao on 8/27/14.
//  Copyright (c) 2014 LightErector. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewModelDelegate.h"
#import "BaseBusiness.h"
#import <ReactiveViewModel.h>
#import "BusinessNameDefine.h"
@interface BaseViewModel : RVMViewModel<BusinessProtocol>
{
@protected
    BaseBusiness *baseBusiness;
}
@property(nonatomic,assign)id<ViewModelDelegate> observer;
@property(nonatomic,strong)RACSignal *rac_isObserverActiveSignal;
- (RACSignal *)creatBusinessWithName:(NSString *)businessName andExecuteWithData:(NSDictionary *)dic;
- (RACSignal *)creatBusinessWithName:(NSString *)businessName andObserver:(id<BusinessProtocol>)observer andExecuteWithData:(NSDictionary *)dic;
@end
