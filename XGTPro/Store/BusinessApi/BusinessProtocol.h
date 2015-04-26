//
//  BusinessProtocol.h
//  XGTPro
//
//  Created by jayden on 15/4/26.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

//@class BaseBusiness;
//
//@protocol DownLoadBusinessDelegate <NSObject>
//-(void)didDownLoadFileOfByteCount:(BaseBusiness *)business forByteCount:(long long)byteCount forTotalByteCount:(long long)totalByteCount;
//@end

@class BaseModel;
@protocol BusinessDelegate <NSObject>

- (void)didBusinessSuccessWithModel:(BaseModel*)model;
- (void)didBusinessFailWithCode:(NSInteger)code andMsg:(NSString *)msg;
- (void)didBusinessErrorWithCode:(NSInteger)code andMsg:(NSString *)msg;
@end


@protocol BusinessProtocol <NSObject>
- (void)setDelegate:(id<BusinessDelegate>)delegate;
- (void)execute:(NSDictionary *)param;
- (void)cancel;
@end