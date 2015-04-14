//
//  UserInfo.m
//  LightErector
//
//  Created by Jayden Zhao on 8/27/14.
//  Copyright (c) 2014 LightErector. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
-(id)initWithDic:(NSDictionary *)dic
{
    if (self=[super init]) {
        _mobilephone=[dic objectForKey:@"mobile"];
         _telephone=[dic objectForKey:@"telphone"];
         _email=[dic objectForKey:@"eamil"];
         _address=[dic objectForKey:@"address"];
         _qq=[dic objectForKey:@"qq"];
    }
    return self;
}

-(NSDictionary *)convertToDic
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjects:@[_mobilephone,_telephone,_email,_address,_qq] forKeys:@[@"mobile",@"telphone",@"eamil",@"address",@"qq"]];
    return dic;
}

@end
