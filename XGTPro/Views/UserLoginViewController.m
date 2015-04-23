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
@property(nonatomic,readonly,strong)UserLoginViewModel *viewModel;
@end

@implementation UserLoginViewController
@dynamic viewModel;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithViewModel:[[UserLoginViewModel alloc] init] nibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithViewModel:[[UserLoginViewModel alloc] init] coder:aDecoder]) {
    }
    return self;
}
- (void)viewDidLoad {   
    [super viewDidLoad];
    
    @weakify(self)

    [[self.userNameField.rac_textSignal filter:^BOOL(NSString *value) {
                return @([[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]);
    }] subscribeNext:^(NSString *value) {
        @strongify(self)
        self.viewModel.userName = value;
    }];
    
    [[self.pwdField.rac_textSignal filter:^BOOL(NSString *value) {
        return @([[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]);
    }] subscribeNext:^(NSString *value) {
        @strongify(self)
        self.viewModel.passwd = value;
    }];
    
    
    self.loginButton.rac_command = [[RACCommand alloc] initWithEnabled:self.viewModel.loginParamValidationSignal signalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self lockViewWithStatus:@"正在登陆..."];
        return [[self.viewModel.loginAction execute:nil] doNext:^(id x) {
            NSLog(@"1232321344%@",x);
        }];
    }];

    
//    RACSignal *enableSignal = [RACSignal combineLatest:@[[self.userNameField.rac_textSignal map:^id(NSString *value) {
//        return @([[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]);
//    }],[self.pwdField.rac_textSignal map:^id(NSString *value) {
//        return @([[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]);
//    }]] reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid){
//        return @([usernameValid boolValue] && [passwordValid boolValue]);
//    }]  ;
//    
//    self.loginButton.rac_command = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal *(id input) {
//        @strongify(self)
//        [self lockViewWithStatus:@"正在登陆..."];
//        return [[[[self.viewModel loginWithUserName:[self.userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] andPwd:[self.pwdField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]] doError:^(NSError *error) {
//            NSLog(@"%@",error.userInfo.allValues[0]);
//        }] doNext:^(id x) {
//            NSLog(@"1232321344%@",x);
//        }] doCompleted:^{
//            NSLog(@"complete");
//        }];
//    }];
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
