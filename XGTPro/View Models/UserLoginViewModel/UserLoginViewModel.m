//
//  UserLoginViewModel.m
//  XGTPro
//
//  Created by jayden on 15/4/20.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import "UserLoginViewModel.h"
#import <ReactiveCocoa.h>

@implementation UserLoginViewModel
-(instancetype)init{
    if (self = [super init]) {
        
        @weakify(self)
        
        _loginParamValidationSignal = [RACSignal combineLatest:@[[[RACObserve(self, userName) filter:^BOOL(id value) {
            return value;
        }] map:^id(NSString *value) {
            return @([[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]);
        }],[[RACObserve(self, passwd) filter:^BOOL(id value) {
            return value;
        }] map:^id(NSString *value) {
            return @([[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]);
        }]] reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid){
            return @([usernameValid boolValue] && [passwordValid boolValue]);
        }];
        
        _loginAction = [[RACCommand alloc] initWithEnabled:_loginParamValidationSignal signalBlock:^RACSignal *(id input) {
            @strongify(self)
             return [self creatBusinessWithName:BUSINESS_USER_LOGIN andExecuteWithData:@{@"username":self.userName,@"password":self.passwd}];
        }];
    }
    return self;
}
-(RACSignal *)loginWithUserName:(NSString *)userName andPwd:(NSString *)pwd{
    return [self creatBusinessWithName:BUSINESS_USER_LOGIN andExecuteWithData:@{@"username":userName,@"password":pwd}];
}
@end
