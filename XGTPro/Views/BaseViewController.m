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

@interface BaseViewController ()
{
}
-(void)unlockView;
-(void)createUIActivityIndicatorView;
@end

@implementation BaseViewController
@synthesize lockViewCount = _lockViewCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

-(void)createUIActivityIndicatorView{
    customActivityIndicatorView = [[CustomActivityIndicatorView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    customActivityIndicatorView.alpha = 0.5;
    customActivityIndicatorView.color=[UIColor blackColor];
    [self.view addSubview:customActivityIndicatorView];
}


-(void)lockView{
    _lockViewCount++;
    if(![customActivityIndicatorView isAnimating])
    {
        self.view.userInteractionEnabled = NO;
        [self.view bringSubviewToFront:customActivityIndicatorView];
        [customActivityIndicatorView startAnimating];
    }
}

-(BOOL)lockViewAddCount{
    if([customActivityIndicatorView isAnimating])
    {
        _lockViewCount++;
        return YES;
    }
    return NO;
}

-(void)unlockView{
    self.view.userInteractionEnabled = YES;
    customActivityIndicatorView.showText = nil;
    [customActivityIndicatorView stopAnimating];
}

-(BOOL)unlockViewSubtractCount{
    if(![customActivityIndicatorView isAnimating])
        return NO;
    
    _lockViewCount--;
    if(_lockViewCount<0)
        _lockViewCount = 0;
    if(_lockViewCount == 0)
        [self unlockView];
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


- (void)viewDidLoad{
    [super viewDidLoad];
    //    [ViewControllerPathManager addViewControllerID:[NSNumber numberWithInt:_viewControllerId]];
    _lockViewCount = 0;
    [self createUIActivityIndicatorView];
    
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

-(void)sendResetMessage
{
   
}

-(void)dealloc
{
    if([self.view isKindOfClass:[TitleBarView class]])
        ((TitleBarView*)self.view).customTitleBar.buttonEventObserver = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showTip:(NSString *)text
{
    [self showTip:text atTop:NO];
}

-(void)showTip:(NSString *)text atTop:(BOOL) isAtTop
{
    UIImage *image=[ImageUtils createImageWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.8] andSize:CGSizeMake(200.0f, 50.0f)];
    BaseCustomMessageBox *baseCustomMessageBox = [[BaseCustomMessageBox alloc] initWithText:text forBackgroundImage:image];
    if (isAtTop) {
      CGRect rect= baseCustomMessageBox.frame;
        rect.origin.y=self.view.frame.origin.y+50;
        baseCustomMessageBox.frame=rect;
    }
    baseCustomMessageBox.tag=10;
    baseCustomMessageBox.animation = YES;
    baseCustomMessageBox.autoCloseTimer = 2;
    [self.view addSubview:baseCustomMessageBox];
}
@end
