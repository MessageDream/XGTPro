//
//  TitleBarAndTableView.m
//  ZhiJiaX
//
//  Created by 95190 on 13-5-28.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import "TitleBarAndTableView.h"

@implementation TitleBarAndTableView
@synthesize tableView = _tableView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}
- (id)initWithFrame:(CGRect)frame tableViewStyle:(UITableViewStyle)style{
    if(self = [self initWithFrame:frame]){
        
    }
    return self;
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
