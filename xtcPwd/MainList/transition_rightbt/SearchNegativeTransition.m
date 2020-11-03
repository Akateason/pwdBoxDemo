//
//  SearchNegativeTransition.m
//  xtcPwd
//
//  Created by teason23 on 2017/12/27.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "SearchNegativeTransition.h"
#import "PwdListController.h"
#import "SearchVC.h"
#import "UIImage+AddFunction.h"
#import "XTColor+MyColors.h"

@implementation SearchNegativeTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //获取动画前后两个VC 和 发生的容器containerView
    PwdListController *toVC = (PwdListController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] ;
    SearchVC *fromVC = (SearchVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] ;
    UIView *containerView = [transitionContext containerView] ;
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC] ;
    
    UIView *topBar = [UIView new] ;
    topBar.backgroundColor = [UIColor whiteColor] ;
    topBar.frame = [containerView convertRect:fromVC.searchBackView.frame
                                     fromView:fromVC.searchBackView.superview] ;
    topBar.layer.cornerRadius = 15. ;
    fromVC.searchBackView.hidden = YES ;
    
    UIImageView *btImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"searchBt"] xt_imageWithTintColor:[UIColor whiteColor]]] ;
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    CGFloat statusHeight = window.windowScene.statusBarManager.statusBarFrame.size.height;

    btImageView.frame = CGRectMake(APP_WIDTH - 16 - 30,
                                   3 + statusHeight,
                                   30, 30) ;
    btImageView.layer.cornerRadius = 15 ;
    btImageView.alpha = 0 ;
    btImageView.backgroundColor = [XTColor xt_main] ;
    
    [containerView insertSubview:toVC.view belowSubview:fromVC.view] ;
    [containerView addSubview:topBar] ;
    [containerView addSubview:btImageView] ;
    
    btImageView.layer.transform = CATransform3DMakeRotation(M_PI / 2, 0, 0, 1) ;
    //发生动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         fromVC.view.alpha = 0.0f ;
                         topBar.frame = CGRectMake(APP_WIDTH - 16 - 30 ,
                                                   3 + statusHeight,
                                                   30, 30) ;
                         btImageView.alpha = 1 ;
                         btImageView.layer.transform = CATransform3DIdentity ;
                     }
                     completion:^(BOOL finished) {
                         [topBar removeFromSuperview] ;
                         [btImageView removeFromSuperview] ;
                         fromVC.searchBackView.hidden = NO ;
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]] ;
                     }] ;
}


@end
