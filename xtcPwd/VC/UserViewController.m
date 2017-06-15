//
//  UserViewController.m
//  xtcPwd
//
//  Created by teason23 on 2017/6/15.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "UserViewController.h"
#import "UIColor+AllColors.h"
#import "JXGesturePasswordView.h"
#import "SVProgressHUD.h"

@interface UserViewController () <JXGesturePasswordViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btClose;
@property (weak, nonatomic) IBOutlet UIButton *btForgetGesture;

@end

@implementation UserViewController

- (void)viewDidLoad
{
    [super viewDidLoad] ;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor xt_d_red] ;
    
    [_btForgetGesture setTitleColor:[UIColor xt_dart] forState:0] ;
    _btForgetGesture.layer.cornerRadius = 5. ;
    _btForgetGesture.backgroundColor = [UIColor xt_light] ;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btCloseOnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES] ;
}


- (IBAction)forgetOpenGesture:(id)sender
{
    JXGesturePasswordView *gesturePasswordView = [[JXGesturePasswordView alloc] init] ;
    gesturePasswordView.backgroundColor = [UIColor xt_d_red] ;
    gesturePasswordView.center = self.view.center;
    gesturePasswordView.delegate = self;
    [self.view addSubview:gesturePasswordView];
}


- (void)gesturePasswordView:(JXGesturePasswordView *)gesturePasswordView
      didFinishDrawPassword:(NSString *)password
{
    if ([password length] <= 4) {
        [SVProgressHUD showErrorWithStatus:@"you have to make more than 4 Numbers"] ;
        return ;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setObject:password forKey:@"gesturePwd"] ;
    [userDefaults synchronize] ;
    [SVProgressHUD showSuccessWithStatus:@"set gesture success !"] ;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [gesturePasswordView removeFromSuperview] ;
    }) ;
    
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
