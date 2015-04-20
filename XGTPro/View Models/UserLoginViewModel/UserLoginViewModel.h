//
//  UserLoginViewModel.h
//  XGTPro
//
//  Created by jayden on 15/4/20.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import "BaseViewModel.h"

@interface UserLoginViewModel : BaseViewModel
-(RACSignal *)loginWithUserName:(NSString *)userName andPwd:(NSString *)pwd;
@end
