//
//  TitleBarView.m
//  ZhiJiaX
//
//  Created by 95190 on 13-5-23.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import "TitleBarView.h"
#import "ImageUtils.h"
//#import "XXNibBridge.h"
//
//@interface TitleBarView () <XXNibBridge>
//
//@end
@implementation TitleBarView
@synthesize customTitleBar = _customTitleBar;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGSize imgSize=CGSizeMake(self.frame.size.width, 44.0f);
        _customTitleBar = [[CustomTitleBar alloc] initWithBackgroundImage:[ImageUtils createImageWithColor:[MainStyle mainLightColor] andSize:imgSize]];
        _customTitleBar.titleFontSize = 18;
        _customTitleBar.style = CustomTitleBar_Style_None;
        _customTitleBar.backgroundColor = [UIColor clearColor];
          [self addSubview:_customTitleBar];
        _customTitleBar.textColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
        
       // _customTitleBar.leftButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"title_bar_return",Res_Image,@"")];
       // _customTitleBar.rightButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"title_bar_home",Res_Image,@"")];
        _customTitleBar.titleText = NSLocalizedStringFromTable(@"SubProductName9",Res_String,@"");
        
        UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, _customTitleBar.frame.size.height, self.frame.size.width, self.frame.size.height-_customTitleBar.frame.size.height)];
        backView.backgroundColor=[MainStyle mainBackColor];
        [self addSubview:backView];
        //_customTitleBar.titleVerticleAlignment=CustomTitleBar_Title_VerticleAlignment_Bottom;
    }
    return self;
}
-(void)setDelegate_soon:(id<CustomTitleBar_ButtonDelegate>)delegate_soon{
    [_customTitleBar.leftButton addTarget:delegate_soon action:@selector(leftButton_onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_customTitleBar.rightButton addTarget:delegate_soon action:@selector(rightButton_onClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)awakeFromNib{
     [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"TitleBarView" owner:self options:nil];
    [self addSubview:self.contentView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
@end
