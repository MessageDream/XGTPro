//
//  BusinessManager.h
//  XGTPro
//
//  Created by Jayden Zhao on 15/4/15.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface BusinessManager : NSObject
+(RACSignal *)excuteWithBusinessName:(NSString *)businessName andParameters:(NSDictionary *)param;
@end
