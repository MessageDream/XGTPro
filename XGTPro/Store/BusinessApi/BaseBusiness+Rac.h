//
//  BaseBusiness+Rac.h
//  XGTPro
//
//  Created by Jayden Zhao on 15/4/15.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import "BaseBusiness.h"

@interface BaseBusiness (Rac)
- (RACSignal *)rac_isActiveSignal;
@end
