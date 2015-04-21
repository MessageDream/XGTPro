//
//  TitleBarAndTableView.h
//  ZhiJiaX
//
//  Created by 95190 on 13-5-28.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@interface TitleBarAndTableView : BaseView
{
@protected
    UITableView *_tableView;
}
@property(nonatomic,readonly)UITableView *tableView;
- (id)initWithFrame:(CGRect)frame tableViewStyle:(UITableViewStyle)style;
@end
