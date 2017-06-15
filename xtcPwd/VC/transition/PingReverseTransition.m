//
//  PingReverseTransition.m
//  AnimationLab
//
//  Created by teason23 on 2017/6/15.
//  Copyright © 2017年 teaason. All rights reserved.
//

#import "PingReverseTransition.h"
#import "PwdListController.h"
#import "UserViewController.h"

@interface PingReverseTransition () <CAAnimationDelegate>
@property (nonatomic,strong)id<UIViewControllerContextTransitioning> transitionContext;
@end

@implementation PingReverseTransition
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return  0.5f;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
    UserViewController * fromVC = (UserViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] ;
    PwdListController *toVC = (PwdListController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] ;
    UIView *containerView = [transitionContext containerView] ;
    UIButton *button = toVC.btUser ;
    
    [containerView insertSubview:toVC.view
                    belowSubview:fromVC.view] ;

    
    //创建两个圆形的 UIBezierPath 实例；一个是 button 的 size ，另外一个则拥有足够覆盖屏幕的半径。最终的动画则是在这两个贝塞尔路径之间进行的
    UIBezierPath *maskfBP =  [UIBezierPath bezierPathWithOvalInRect:button.frame];
    CGPoint startPoint = CGPointMake(button.center.x - 0, button.center.y - CGRectGetMaxY(toVC.view.bounds));
    CGFloat radius = sqrt((startPoint.x * startPoint.x) + (startPoint.y * startPoint.y));
    UIBezierPath *masksBP = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(button.frame, -radius, -radius)];
    
    
    //创建一个 CAShapeLayer 来负责展示圆形遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer] ;
    maskLayer.path = maskfBP.CGPath ; //将它的 path 指定为最终的 path 来避免在动画完成后会回弹
    fromVC.view.layer.mask = maskLayer ;
    
    //创建一个关于 path 的 CABasicAnimation 动画来从 circleMaskPathInitial.CGPath 到 circleMaskPathFinal.CGPath 。同时指定它的 delegate 来在完成动画时做一些清除工作
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"] ;
    maskLayerAnimation.fromValue = (__bridge id)(masksBP.CGPath) ;
    maskLayerAnimation.toValue = (__bridge id)((maskfBP.CGPath)) ;
    maskLayerAnimation.duration = [self transitionDuration:transitionContext] ;
    maskLayerAnimation.delegate = self ;
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"] ;
}

#pragma mark - CABasicAnimation的Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //告诉 iOS 这个 transition 完成
    [self.transitionContext completeTransition:![self. transitionContext transitionWasCancelled]];
    //清除 fromVC 的 mask
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}

@end
