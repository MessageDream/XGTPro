//
//  BaseViewController.h
//  LightErector
//
//  Created by Jayden Zhao on 8/27/14.
//  Copyright (c) 2014 LightErector. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResDefine.h"
#import "TextFiledReturnEditingDelegate.h"

@class BaseViewModel;

#define PUSHNOTIFICATIONID @"PUSHNOTIFICATIONID"

@interface BaseViewController : UIViewController<TextFiledReturnEditingDelegate>

@property(nonatomic,assign)UIInterfaceOrientation orientation;
@property(nonatomic,weak)BaseViewModel *viewModel;

-(void)destroyDataBeforeDealloc;
-(void)lockViewWithStatus:(NSString *)status;
-(BOOL)unlockViewSubtractCount;
-(CGRect)createViewFrame;
-(void)sendShowTabBarMessage;
-(void)sendHideTabBarMessage;
-(void)sendSwichTabBarMessageAtIndex:(NSInteger)index;
-(void)sendResetMessage;
-(void)showTip:(NSString *)text;
-(void)showTip:(NSString *)text atTop:(BOOL) isAtTop;
@end
