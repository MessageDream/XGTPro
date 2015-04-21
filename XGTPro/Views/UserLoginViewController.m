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

@end

@implementation UserLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [[UserLoginViewModel alloc] init];
    @weakify(self)
    self.loginButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [[[[((UserLoginViewModel *) self.viewModel) loginWithUserName:@"user" andPwd:@"password"] doError:^(NSError *error) {
            NSLog(@"%@",[error.userInfo objectForKey:@"msg"]);
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
