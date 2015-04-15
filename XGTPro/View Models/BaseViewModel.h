//
//  BaseDataModel.h
//  LightErector
//
//  Created by Jayden Zhao on 8/27/14.
//  Copyright (c) 2014 LightErector. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewModelDelegate.h"
#import "BaseBusiness.h"
#import <ReactiveViewModel.h>
@interface BaseViewModel : RVMViewModel<BusinessProtocol>
{
@protected
    BaseBusiness *baseBusiness;
}
@property(nonatomic,assign)id<ViewModelDelegate> observer;
- (void)creatBusinessWithId:(NSInteger)businessId andExecuteWithData:(NSDictionary *)dic;
- (void)creatBusinessWithId:(NSInteger)businessId andObserver:(id<BusinessProtocol>)observer andExecuteWithData:(NSDictionary *)dic;
@end
