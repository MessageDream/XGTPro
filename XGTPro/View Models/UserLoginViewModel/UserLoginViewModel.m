//
//  UserLoginViewModel.m
//  XGTPro
//
//  Created by jayden on 15/4/20.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import "UserLoginViewModel.h"

@implementation UserLoginViewModel
-(RACSignal *)loginWithUserName:(NSString *)userName andPwd:(NSString *)pwd{
    return [self creatBusinessWithName:BUSINESS_USER_LOGIN andExecuteWithData:@{@"username":userName,@"password":pwd}];
}
@end
