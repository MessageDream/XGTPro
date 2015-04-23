//
//  HttpStautsCode.m
//  LightErector
//
//  Created by Jayden Zhao on 13-4-27.
//  Copyright (c) 2013年 LightErector. All rights reserved.
//

#import "HttpErrorCodeManager.h"
@implementation HttpErrorCodeManager

+(NSString*)getDesFromErrorCode:(HttpErrorCode)code
{
    if(code == HttpErrorCode_TimerOut)
        return NSLocalizedString(@"HttpError2", nil);
    else if(code == HttpErrorCode_WriteFileFail)
        return NSLocalizedString(@"HttpError3", nil);
    else if(code == HttpErrorCode_NetworkFail)
        return NSLocalizedString(@"HttpError4", nil);
    
    return NSLocalizedString(@"HttpError1", nil);
}
@end
