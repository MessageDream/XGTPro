//
//  BaseViewController.h
//  LightErector
//
//  Created by Jayden Zhao on 8/27/14.
//  Copyright (c) 2014 LightErector. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFiledReturnEditingDelegate.h"

@class BaseViewModel;

#define PUSHNOTIFICATIONID @"PUSHNOTIFICATIONID"

@interface BaseViewController : UIViewController<TextFiledReturnEditingDelegate>
{
}
@property(nonatomic,assign)UIInterfaceOrientation orientation;
@property(nonatomic,readonly,strong)BaseViewModel *viewModel;

- (instancetype)initWithViewModel:(BaseViewModel *)viewModel;
- (instancetype)initWithViewModel:(BaseViewModel *)viewModel nibName:(NSString *)nibName bundle:(NSBundle *)bundle;
- (instancetype)initWithViewModel:(BaseViewModel *)viewModel coder:(NSCoder *)aDecoder;

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
