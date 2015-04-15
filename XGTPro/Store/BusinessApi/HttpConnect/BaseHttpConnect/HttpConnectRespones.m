//
//  HttpConnectRespones.m
//  HttpConnect
//
//  Created by Jayden Zhao on 13-3-31.
//  Copyright (c) 2013年 LightErector. All rights reserved.
//

#import "HttpConnectRespones.h"

@implementation HttpConnectRespones
@synthesize responesHead = _responesHead;
@synthesize responesBody = _responesBody;

-(void)dealloc
{
    self.responesHead = nil;
    self.responesBody = nil;
}
@end
