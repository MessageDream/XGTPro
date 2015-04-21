//
//  BaseViewController.m
//  LightErector
//
//  Created by Jayden Zhao on 8/27/14.
//  Copyright (c) 2014 LightErector. All rights reserved.
//
#import "TitleBarView.h"
#import "BaseViewController.h"
#import "BaseCustomMessageBox.h"
#import "ImageUtils.h"
#import "MainStyle.h"
#import "BaseViewModel.h"
#import <SVProgressHUD.h>
#import <ReactiveCocoa.h>

@interface BaseViewController ()
{
    @protected
        int _lockViewCount;
}
-(void)unlockView;
@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _orientation = [UIApplication sharedApplication].statusBarOrientation;
    }
    return self;
}

-(id)init{
    if (self=[super init]) {
        _orientation = [UIApplication sharedApplication].statusBarOrientation;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    @weakify(self)
    [self.viewModel.rac_isObserverActiveSignal subscribeNext:^(NSError *error) {
        @strongify(self)
        [self showTip:error.userInfo.allValues[0]];
    } completed:^{
        @strongify(self)
        [self unlockViewSubtractCount];
    }];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.8]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
}

//-(void)didDataModelNoticeSucess:(BaseDataModel*)baseDataModel forBusinessType:( BusinessType)businessID{
//    [self unlockViewSubtractCount];
//#ifdef DEBUG_LOG
//    NSLog(@"%d",(int)businessID);
//    NSLog(@"sucess");
//#endif
//}
//
//-(void)didDataModelNoticeFail:(BaseDataModel*)baseDataModel forBusinessType:( BusinessType)businessID forErrorCode:(NSInteger)errorCode forErrorMsg:(NSString*)errorMsg{
//    [self unlockViewSubtractCount];
//#ifdef DEBUG_LOG
//    NSLog(@"%d",(int)businessID);
//#endif
//    NSString *error = @"";
//    if(errorMsg==nil)
//        return;
//    error = [error stringByAppendingString:errorMsg];
//    [self showTip:error];
//#ifdef DEBUG_LOG
//    NSLog(@"%@",error);
//#endif
//    
//}


-(void)lockViewWithStatus:(NSString *)status{
    if(![SVProgressHUD isVisible]){
        [SVProgressHUD showWithStatus:status];
    }else{
        [SVProgressHUD setStatus:status];
    }
}

-(void)unlockView{
    [SVProgressHUD dismiss];
}

-(BOOL)unlockViewSubtractCount{
    if(![SVProgressHUD isVisible])
        return NO;
    
    [SVProgressHUD popActivity];
    return YES;
}

-(CGRect)createViewFrame{
    CGRect frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = [UIScreen mainScreen].applicationFrame.size.width;
    frame.size.height = [UIScreen mainScreen].applicationFrame.size.height;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7)
        frame.origin.y = [UIScreen mainScreen].applicationFrame.origin.y;
    return frame;
}

-(IBAction)textFiledReturnEditing:(id)sender{
    [sender resignFirstResponder];
}

-(void)destroyDataBeforeDealloc{
    
}

-(void)sendShowTabBarMessage{

}

-(void)sendHideTabBarMessage{
    
}

-(void)sendSwichTabBarMessageAtIndex:(NSInteger)index{

}

-(void)sendResetMessage{
   
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)showTip:(NSString *)text{
    [self showTip:text atTop:NO];
}

-(void)showTip:(NSString *)text atTop:(BOOL) isAtTop{
    [SVProgressHUD showInfoWithStatus:text];
}

-(void)dealloc{
    if([self.view isKindOfClass:[TitleBarView class]])
        ((TitleBarView*)self.view).customTitleBar.buttonEventObserver = nil;
}
@end
