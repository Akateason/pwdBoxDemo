//
//  SearchPositiveTransition.m
//  xtcPwd
//
//  Created by teason23 on 2017/12/27.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "SearchPositiveTransition.h"
#import "PwdListController.h"
#import "SearchVC.h"
#import "UIImage+AddFunction.h"
#import "UIColor+AllColors.h"

@implementation SearchPositiveTransition

#pragma mark - UIViewControllerAnimatedTransitioning <NSObject>
// This is used for percent driven interactive transitions, as well as for
// container controllers that have companion animations that might need to
// synchronize with the main animation.
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return .8 + 0.65 + .4 + .3 ;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    PwdListController *fromVC = (PwdListController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] ;
    SearchVC *toVC = (SearchVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] ;
    UIView *containerView = [transitionContext containerView] ;
    
    UIView *snapShotSearchbt = [fromVC.btSearch snapshotViewAfterScreenUpdates:NO] ;
    snapShotSearchbt.frame = [containerView convertRect:fromVC.btSearch.frame
                                               fromView:fromVC.btSearch.superview] ;
    fromVC.btSearch.hidden = YES ;
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC] ;
    toVC.view.alpha = 0 ;
    
    UIImageView *closeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"close2"]] ;
    closeImage.backgroundColor = [UIColor whiteColor] ;
    closeImage.layer.cornerRadius = fromVC.btSearch.frame.size.width / 2. ;
    closeImage.frame = [containerView convertRect:fromVC.btSearch.frame
                                         fromView:fromVC.btSearch.superview] ;
    
    UIView *imageBackView = [UIView new] ;
    imageBackView.backgroundColor = [UIColor whiteColor] ;
    imageBackView.frame = closeImage.frame ;
    imageBackView.layer.cornerRadius = fromVC.btSearch.frame.size.width / 2. ;
    
    UIView *backView = [UIView new] ;
    backView.frame = CGRectMake(0, 0, APP_WIDTH, 64) ;
    backView.backgroundColor = [UIColor xt_main] ;
    
    // 把动画前后的两个ViewController加到容器中,顺序很重要,snapShotView在上方
    [containerView addSubview:backView] ;
    backView.hidden = YES ;
    [containerView addSubview:imageBackView] ;
    [containerView addSubview:snapShotSearchbt] ;
    [containerView addSubview:closeImage] ;
    closeImage.alpha = 0 ;
    [containerView addSubview:toVC.view] ;
    
    // animation
    [UIView transitionWithView:containerView
                      duration:.8
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        [containerView layoutIfNeeded] ;
                        snapShotSearchbt.layer.transform = CATransform3DMakeRotation(M_PI / 2, 0, 0, 1) ;
                        snapShotSearchbt.alpha = 0 ;
                        closeImage.alpha = 1 ;
                        closeImage.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1) ;
                        closeImage.frame = CGRectMake(0, 0, 20, 20) ;
                        closeImage.center = fromVC.btSearch.center ;
                    } completion:^(BOOL finished) {

                        [containerView layoutIfNeeded] ;
                        backView.hidden = NO ;

                        [UIView animateWithDuration:0.65
                                         animations:^{
                                             imageBackView.frame = CGRectMake(0, 0, APP_WIDTH - 16 * 2, 30) ;
                                             imageBackView.center = CGPointMake(APP_WIDTH / 2, fromVC.btSearch.center.y) ;
                                             backView.frame = APPFRAME ;
                                         }
                                         completion:^(BOOL finished) {
                                             
                                              [UIView animateWithDuration:.3
                                                               animations:^{
                                                  toVC.view.alpha = 1. ;
                                              } completion:^(BOOL finished) {
                                                  [backView removeFromSuperview] ;
                                                  [imageBackView removeFromSuperview] ;
                                                  [closeImage removeFromSuperview] ;
                                                  [snapShotSearchbt removeFromSuperview] ;
                                                  fromVC.btSearch.hidden = NO ;
                                                  
                                                  [transitionContext completeTransition:!transitionContext.transitionWasCancelled] ;
                                              }] ;
                                             
                                         }] ;
                        
                    }] ;
    
}

@end
