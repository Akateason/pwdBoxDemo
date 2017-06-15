//
//  PingTransition.m
//  AnimationLab
//
//  Created by teason23 on 2017/6/15.
//  Copyright © 2017年 teaason. All rights reserved.
//

#import "PingTransition.h"
#import "PwdListController.h"
#import "UserViewController.h"

@interface PingTransition () <CAAnimationDelegate>
@property (nonatomic,strong)id<UIViewControllerContextTransitioning> transitionContext;
@end

@implementation PingTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return  0.5f;
}

//
//    CGRectInset ——
//
//    CGRect CGRectInset (
//                        CGRect rect,
//                        CGFloat dx,
//                        CGFloat dy
//                        ); 该结构体的应用是以原rect为中心，再参考dx，dy，进行缩放或者放大。
//
//    CGRectOffset ——
//
//    CGRect CGRectOffset(
//                        CGRect rect,
//                        CGFloat dx,
//                        CGFloat dy
//                        ); 相对于源矩形原点rect（左上角的点）沿x轴和y轴偏移, 在rect基础上沿x轴和y轴偏移
//
//    CGRectGetMinX(CGRect rect) rect最左边的X坐标 CGRectGetMidX(CGRect rect) rect中点的X坐标 CGRectGetMinY(CGRect rect) rect最上方的Y坐标 CGRectGetMaxY(CGRect rect) rect最下方的Y坐标

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
    PwdListController * fromVC = (PwdListController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] ;
    UserViewController *toVC = (UserViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] ;
    UIView *containerView = [transitionContext containerView] ;
    UIButton *button = fromVC.btUser;
    [containerView addSubview:toVC.view] ;
    

    //创建两个圆形的 UIBezierPath 实例；一个是 button 的 size ，另外一个则拥有足够覆盖屏幕的半径。最终的动画则是在这两个贝塞尔路径之间进行的
    UIBezierPath *maskStartBP =  [UIBezierPath bezierPathWithOvalInRect:button.frame];
    
    //    CGPoint finalPoint = CGPointMake(button.center.x - 0, button.center.y - CGRectGetMaxY(toVC.view.bounds));
    CGPoint finalPoint = CGPointMake(button.center.x - 0, button.center.y - CGRectGetMaxY(toVC.view.bounds));
    CGFloat radius = sqrt((finalPoint.x * finalPoint.x) + (finalPoint.y * finalPoint.y));
    UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(button.frame, -radius, -radius)];
    
    
    //创建一个 CAShapeLayer 来负责展示圆形遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer] ;
    maskLayer.path = maskFinalBP.CGPath ; //将它的 path 指定为最终的 path 来避免在动画完成后会回弹
    toVC.view.layer.mask = maskLayer ;
    
    
    //创建一个关于 path 的 CABasicAnimation 动画来从 circleMaskPathInitial.CGPath 到 circleMaskPathFinal.CGPath 。同时指定它的 delegate 来在完成动画时做一些清除工作
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"] ;
    maskLayerAnimation.fromValue = (__bridge id)(maskStartBP.CGPath) ;
    maskLayerAnimation.toValue = (__bridge id)((maskFinalBP.CGPath)) ;
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
