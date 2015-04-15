//
//  BaseBusinessHttpConnect.h
//  G_NetLink
//
//  Created by Jayden Zhao on 14-3-20.
//  Copyright (c) 2014年 LightErector. All rights reserved.
//

#import "BaseHttpConnect.h"


@interface JsonHttpConnect : BaseHttpConnect

-(void)setUrlParam:(NSDictionary *)theParam;
- (void)sendWithParam:(NSDictionary *)param;
@end
