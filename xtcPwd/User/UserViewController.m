//
//  UserViewController.m
//  xtcPwd
//
//  Created by teason23 on 2017/6/15.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "UserViewController.h"
#import "XTColor+MyColors.h"
#import "SVProgressHUD.h"
#import "PingReverseTransition.h"
#import "UIImage+AddFunction.h"
#import <UINavigationController+FDFullscreenPopGesture.h>
#import "FilterCondition.h"
#import "AliPayViews.h"
#import "KeychainData.h"
#import "SetpasswordViewController.h"


@interface UserViewController () <UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btClose;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cateBts;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *sortBts;
@property (weak, nonatomic) IBOutlet UIButton *sortChangeBt;
@property (weak, nonatomic) IBOutlet UIButton *cancelBt;
@property (weak, nonatomic) IBOutlet UIButton *confirmBt;
@property (weak, nonatomic) IBOutlet UIButton *btOpenPwd;

@end

@implementation UserViewController

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad] ;
    self.fd_interactivePopDisabled = YES ;
    [self setupUI] ;
    
    FilterCondition *filter = [FilterCondition sharedSingleton] ;
    for (UIButton *bt in _cateBts) bt.selected = NO ;
    ((UIButton *)self.cateBts[filter.filterCate]).selected = YES ;
    for (UIButton *bt in _sortBts) bt.selected = NO ;
    ((UIButton *)self.sortBts[filter.sortByType]).selected = YES ;
    _sortChangeBt.selected = filter.isAscOrDesc ;
}

- (void)setupUI {
    self.view.backgroundColor = [XTColor xt_main] ;
    
    [_btClose setImage:[[UIImage imageNamed:@"face"] imageWithTintColor:[UIColor whiteColor]]
              forState:0] ;
    
    [self.view setNeedsLayout] ;
    [self.view layoutIfNeeded] ;
    
    for (UIButton *bt in _cateBts) {
        [bt setTitleColor:[XTColor xt_main] forState:UIControlStateSelected] ;
        [bt setTitleColor:[XTColor xt_text_light] forState:UIControlStateNormal] ;
        bt.layer.cornerRadius = bt.frame.size.width / 2. ;
    }
    
    for (UIButton *bt in _sortBts) {
        [bt setTitleColor:[XTColor xt_main] forState:UIControlStateSelected] ;
        [bt setTitleColor:[XTColor xt_text_light] forState:UIControlStateNormal] ;
        bt.layer.cornerRadius = bt.frame.size.width / 2. ;
    }
    
    _sortChangeBt.backgroundColor = [XTColor xt_main] ;
    [_sortChangeBt setTitleColor:[UIColor whiteColor] forState:0] ;
    _sortChangeBt.layer.borderColor = [UIColor whiteColor].CGColor ;
    _sortChangeBt.layer.borderWidth = 1. ;
    _sortChangeBt.layer.cornerRadius = _sortChangeBt.frame.size.height / 2. ;
    _sortChangeBt.layer.masksToBounds = YES ;
    [_sortChangeBt setTitle:@"ASC"
                   forState:UIControlStateSelected] ;
    [_sortChangeBt setTitle:@"DESC"
                   forState:UIControlStateNormal] ;
    
    _cancelBt.layer.borderColor = [UIColor whiteColor].CGColor ;
    _cancelBt.layer.borderWidth = 1. ;
    _cancelBt.layer.cornerRadius = 15. ;
    _cancelBt.layer.masksToBounds = YES ;
    _cancelBt.backgroundColor = nil ;
    
    _confirmBt.layer.cornerRadius = 15. ;
    _confirmBt.layer.masksToBounds = YES ;
    _confirmBt.backgroundColor = [UIColor whiteColor] ;
    [_confirmBt setTitleColor:[XTColor xt_main] forState:0] ;

    _btOpenPwd.backgroundColor = [UIColor whiteColor] ;
    [_btOpenPwd setTitleColor:[XTColor xt_main] forState:0] ;
    _btOpenPwd.layer.cornerRadius = CGRectGetWidth(_btOpenPwd.frame) / 2. ;
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

- (IBAction)btOpenPwdOnClick:(id)sender {
    BOOL isSave = [KeychainData isSave]; //是否有保存
    [KeychainData forgotPsw] ;
    SetpasswordViewController *setpass = [[SetpasswordViewController alloc] init];
    setpass.string = @"重置密码";
    [self presentViewController:setpass animated:YES completion:nil];
}

- (IBAction)btCloseOnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)confirmBtOnClcik:(id)sender {
    
    [self shakeAnimation:sender
              completion:^(BOOL finished) {

                  [self.navigationController popViewControllerAnimated:YES] ;
                  
                  __block NSUInteger indexCate = 0 , indexSort = 0 ;
                  [_cateBts enumerateObjectsUsingBlock:^(UIButton *bt, NSUInteger idx, BOOL * _Nonnull stop) {
                      if (bt.selected) indexCate = idx ;
                  }] ;
                  [_sortBts enumerateObjectsUsingBlock:^(UIButton *bt, NSUInteger idx, BOOL * _Nonnull stop) {
                      if (bt.selected) indexSort = idx ;
                  }] ;
                  
                  [[FilterCondition sharedSingleton] setupWithSortCate:indexCate
                                                             ascOrDesc:_sortChangeBt.selected
                                                            sortByType:indexSort] ;
                  [self.delegate confirmWithFilter:[FilterCondition sharedSingleton]] ;
                  
              }] ;
}

- (IBAction)cancelBtOnClick:(id)sender {
    [self shakeAnimation:sender
              completion:^(BOOL finished) {
                  [self.navigationController popViewControllerAnimated:YES] ;
              }] ;
}

- (IBAction)cateBtsOnClick:(UIButton *)sender {
    for (UIButton *bt in _cateBts) {
        bt.selected = NO ;
    }
    sender.selected = YES ;

    [self turnOverAnimation:sender
                 completion:nil] ;
}

- (IBAction)sortBtsOnClick:(UIButton *)sender {
    for (UIButton *bt in _sortBts) {
        bt.selected = NO ;
    }
    sender.selected = YES ;
    
    [self turnOverAnimation:sender
                 completion:nil] ;
}

- (void)shakeAnimation:(UIButton *)button
               completion:(void (^)(BOOL finished))completion
{
    button.transform = CGAffineTransformTranslate(button.transform, 0, 10) ;
    [UIView animateWithDuration:0.6
                          delay:0.
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         button.transform = CGAffineTransformIdentity ;
                     }
                     completion:completion] ;
}

- (void)turnOverAnimation:(UIButton *)button
               completion:(void (^)(BOOL finished))completion
{
    button.transform = arc4random() % 2 > 0 ? CGAffineTransformMakeScale(-1.0, 1.0) : CGAffineTransformMakeScale(1.0, -1.0) ;
    [UIView animateWithDuration:0.6
                          delay:0.
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         button.transform = CGAffineTransformIdentity ;
                     }
                     completion:completion] ;
}

- (IBAction)sortChangeBtOnClick:(UIButton *)sender {
    sender.selected = !sender.selected ;
    [self shakeAnimation:sender
              completion:nil] ;
}

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        PingReverseTransition *pingInvert = [PingReverseTransition new];
        return pingInvert;
    }
    else {
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
