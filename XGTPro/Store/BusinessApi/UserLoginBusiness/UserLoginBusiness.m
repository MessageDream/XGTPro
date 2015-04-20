//
//  UserLoginBusiness.m
//  XGTPro
//
//  Created by jayden on 15/4/16.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import "UserLoginBusiness.h"
#import "UserModel.h"

@implementation UserLoginBusiness
-(instancetype)init{
    if(self = [super init]){
        _httpConnect.baseUrl=API_ADDRESS;
        _httpConnect.requestPath = [NSString stringWithFormat: @"/mobile/%@.php?action=checklogin",ACTION_PATH];
        _httpConnect.resquestType = HTTP_REQUEST_POST;
    }
    return self;
}

- (BaseModel *)parseModelFromDic:(NSDictionary *)responseBodyDic{
    return [[UserModel alloc] initWithDictionary:responseBodyDic error:nil];
}
@end
