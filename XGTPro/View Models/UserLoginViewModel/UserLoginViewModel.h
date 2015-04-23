//
//  UserLoginViewModel.h
//  XGTPro
//
//  Created by jayden on 15/4/20.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import "BaseViewModel.h"
@class RACCommand;

@interface UserLoginViewModel : BaseViewModel
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *passwd;
@property(nonatomic,readonly,strong)RACCommand *loginAction;
@property(nonatomic,readonly,strong)RACSignal *loginParamValidationSignal;
-(RACSignal *)loginWithUserName:(NSString *)userName andPwd:(NSString *)pwd;
@end
