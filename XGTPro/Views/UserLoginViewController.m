//
//  UserLoginViewController.m
//  XGTPro
//
//  Created by jayden on 15/4/20.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import "UserLoginViewController.h"
#import "UserLoginViewModel.h"
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>

@interface UserLoginViewController ()
@property(nonatomic,strong)UserLoginViewModel *loginViewModel;
@end

@implementation UserLoginViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
       self.viewModel = self.loginViewModel = [[UserLoginViewModel alloc] init];
    }
    return self;
}
- (void)viewDidLoad {   
    [super viewDidLoad];
    
    @weakify(self)
    self.loginButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self lockViewWithStatus:@"正在登陆。。。"];
        return [[[[self.loginViewModel loginWithUserName:@"user" andPwd:@"password"] doError:^(NSError *error) {
            NSLog(@"%@",error.userInfo.allValues[0]);
        }] doNext:^(id x) {
            NSLog(@"1232321344%@",x);
        }] doCompleted:^{
            NSLog(@"complete");
        }];
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
