//
//  CellPositiveTransition.m
//  xtcPwd
//
//  Created by teason23 on 2017/12/25.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "CellPositiveTransition.h"
#import "PwdListController.h"
#import "DetailViewController.h"
#import "ListCell.h"
#import "UIColor+AllColors.h"

@implementation CellPositiveTransition

#pragma mark - UIViewControllerAnimatedTransitioning <NSObject>
// This is used for percent driven interactive transitions, as well as for
// container controllers that have companion animations that might need to
// synchronize with the main animation.
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1. + .8 + .6 ;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    PwdListController *fromVC = (PwdListController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] ;
    DetailViewController *toVC   = (DetailViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] ;
    UIView *containerView = [transitionContext containerView] ;
    
    // 对Cell上的 imageView 截图，同时将这个 imageView 本身隐藏
    ListCell *cell = (ListCell *)[fromVC.table cellForRowAtIndexPath:[fromVC.table indexPathForSelectedRow]] ;
    UIView *snapShotImageView = [cell.image snapshotViewAfterScreenUpdates:NO] ;
    snapShotImageView.frame = fromVC.finalCellRect = [containerView convertRect:cell.image.frame
                                                                       fromView:cell.image.superview] ;
    cell.image.hidden = YES ;
    
    UIView *backView = [UIView new] ;
    backView.backgroundColor = [UIColor xt_bg] ;
    backView.layer.cornerRadius = 5 ;
    backView.frame = [containerView convertRect:cell.backView.frame
                                       fromView:cell.backView.superview] ;
    
    UIView *snapBackView = [cell.backView snapshotViewAfterScreenUpdates:NO] ;
    snapBackView.frame = [containerView convertRect:cell.backView.frame
                                           fromView:cell.backView.superview] ;
    cell.backView.hidden = YES ;
    cell.hidden = YES ;
    
    // 设置第二个控制器的位置、透明度
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC] ;
    toVC.view.alpha = 0 ;
    toVC.image.hidden = YES ;
    
    // 把动画前后的两个ViewController加到容器中,顺序很重要,snapShotView在上方
    [containerView addSubview:backView] ;
    [containerView addSubview:snapBackView] ;
    [containerView addSubview:toVC.view] ;
    [containerView addSubview:snapShotImageView] ;
    
    snapBackView.layer.transform = CATransform3DMakeTranslation(0, 10, 0) ;
    [UIView animateWithDuration:1.
                          delay:0.
         usingSpringWithDamping:0.1f
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         snapBackView.layer.transform = CATransform3DIdentity ;
                     }
                     completion:^(BOOL finished) {
                         cell.hidden = NO ;
                         [snapBackView removeFromSuperview] ;
                         
                         [UIView animateWithDuration:.8
                                          animations:^{
                                              [containerView layoutIfNeeded] ;
                                              backView.frame = [containerView convertRect:toVC.view.frame
                                                                                         fromView:toVC.view.superview] ;
                                              
                                              snapShotImageView.frame = [containerView convertRect:toVC.image.frame
                                                                                          fromView:toVC.image.superview] ;
                                          }
                                          completion:^(BOOL finished) {
                                              //为了让回来的时候，cell上的图片显示，必须要让cell上的图片显示出来
                                              toVC.image.hidden = NO ;
                                              cell.image.hidden = NO ;
                                              cell.backView.hidden = NO ;
                                              
                                              [UIView animateWithDuration:.6
                                                                    delay:0
                                                                  options:UIViewAnimationOptionCurveLinear
                                                               animations:^{
                                                                   toVC.view.alpha = 1.0 ;
                                                               }
                                                               completion:^(BOOL finished) {
                                                                   [snapShotImageView removeFromSuperview] ;
                                                                   [backView removeFromSuperview] ;
                                                                   //告诉系统动画结束
                                                                   [transitionContext completeTransition:!transitionContext.transitionWasCancelled] ;
                                                               }] ;
                                          }] ;

                         
                     }] ;
    
}

@end