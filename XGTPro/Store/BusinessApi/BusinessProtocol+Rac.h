//
//  BusinessProtocol+Rac.h
//  XGTPro
//
//  Created by jayden on 15/4/26.
//  Copyright (c) 2015年 jayden. All rights reserved.
//
#import <ReactiveCocoa.h>
@protocol BusinessRACProtocol <NSObject>
- (RACSignal *)rac_isActiveSignal;
@end
