//
//  DataModelDelegate.h
//  LightErector
//
//  Created by Jayden Zhao on 8/27/14.
//  Copyright (c) 2014 LightErector. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ViewModelDelegate;

@protocol ViewModelDelegate <NSObject>
//-(void)didDataModelNoticeSucess:(BaseDataModel*)baseDataModel forBusinessType:( BusinessType)businessID;
//-(void)didDataModelNoticeFail:(BaseDataModel*)baseDataModel forBusinessType:(BusinessType)businessID forErrorCode:(NSInteger)errorCode forErrorMsg:(NSString*)errorMsg;
@end


@protocol ViewModelTransferFileDelegate <NSObject>
//-(void)didDataModelNoticeDownLoadFileing:(BaseDataModel*)baseDataModel forByteCount:(long long)byteCount forTotalByteCount:(long long)totalByteCount;
@end