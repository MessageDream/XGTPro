//
//  BusinessManager.h
//  XGTPro
//
//  Created by Jayden Zhao on 15/4/15.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusinessProtocol.h"

@class RACSignal;

@interface BusinessManager : NSObject
+(RACSignal *)excuteWithBusinessName:(NSString *)businessName andDelegate:(id<BusinessDelegate>)delegate andParameters:(NSDictionary *)param;
+(RACSignal *)excuteWithBusinessName:(NSString *)businessName andParameters:(NSDictionary *)param;
@end
