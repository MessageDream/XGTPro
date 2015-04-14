//
//  BaseViewController.h
//  LightErector
//
//  Created by Jayden Zhao on 8/27/14.
//  Copyright (c) 2014 LightErector. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResDefine.h"
#import "CustomActivityIndicatorView.h"
#import "TextFiledReturnEditingDelegate.h"
#import "DataModelDelegate.h"
#import "User.h"

#define PUSHNOTIFICATIONID @"PUSHNOTIFICATIONID"

@interface BaseViewController : UIViewController<DataModelDelegate,TextFiledReturnEditingDelegate>
{
@protected
    User *user;
    CustomActivityIndicatorView *customActivityIndicatorView;
    int _lockViewCount;

}
@property(nonatomic,readonly)int lockViewCount;
@property(nonatomic,assign)UIInterfaceOrientation orientation;

-(void)destroyDataBeforeDealloc;
-(void)lockView;
-(BOOL)lockViewAddCount;
-(BOOL)unlockViewSubtractCount;
-(CGRect)createViewFrame;
-(void)sendShowTabBarMessage;
-(void)sendHideTabBarMessage;
-(void)sendSwichTabBarMessageAtIndex:(NSInteger)index;
-(void)sendResetMessage;
-(void)showTip:(NSString *)text;
-(void)showTip:(NSString *)text atTop:(BOOL) isAtTop;
@end