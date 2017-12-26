//
//  UserViewController.m
//  xtcPwd
//
//  Created by teason23 on 2017/6/15.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "UserViewController.h"
#import "UIColor+AllColors.h"
#import "SVProgressHUD.h"
#import "PingReverseTransition.h"
#import "UIImage+AddFunction.h"
#import <UINavigationController+FDFullscreenPopGesture.h>

@interface UserViewController () <UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btClose;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cateBts;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *sortBts;
@property (weak, nonatomic) IBOutlet UIButton *sortChangeBt;
@property (weak, nonatomic) IBOutlet UIButton *cancelBt;
@property (weak, nonatomic) IBOutlet UIButton *confirmBt;
@end

@implementation UserViewController

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad] ;
    self.fd_interactivePopDisabled = YES ;
    
    self.view.backgroundColor = [UIColor xt_main] ;
    
    [_btClose setImage:[[UIImage imageNamed:@"face"] imageWithTintColor:[UIColor whiteColor]] forState:0] ;
    
    for (UIButton *bt in _cateBts) {
        [bt setTitleColor:[UIColor xt_main] forState:0] ;
        bt.layer.cornerRadius = bt.frame.size.width / 2. ;
    }
    
    for (UIButton *bt in _sortBts) {
        [bt setTitleColor:[UIColor xt_main] forState:0] ;
        bt.layer.cornerRadius = bt.frame.size.width / 2. ;
    }
    
    _sortChangeBt.backgroundColor = [UIColor xt_main] ;
    [_sortChangeBt setTitleColor:[UIColor whiteColor] forState:0] ;
    _sortChangeBt.layer.borderColor = [UIColor whiteColor].CGColor ;
    _sortChangeBt.layer.borderWidth = 1. ;
    _sortChangeBt.layer.cornerRadius = 15. ;
    _sortChangeBt.layer.masksToBounds = YES ;
    
    _cancelBt.layer.borderColor = [UIColor whiteColor].CGColor ;
    _cancelBt.layer.borderWidth = 1. ;
    _cancelBt.layer.cornerRadius = 15. ;
    _cancelBt.layer.masksToBounds = YES ;
    
    _confirmBt.layer.cornerRadius = 15. ;
    _confirmBt.layer.masksToBounds = YES ;
    _confirmBt.backgroundColor = [UIColor whiteColor] ;
    [_confirmBt setTitleColor:[UIColor xt_main] forState:0] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO] ;
    self.navigationController.delegate = self ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - acitons

- (IBAction)btCloseOnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)confirmBtOnClcik:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)cancelBtOnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}


#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop)
    {
        PingReverseTransition *pingInvert = [PingReverseTransition new];
        return pingInvert;
    }
    else{
        return nil;
    }
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
