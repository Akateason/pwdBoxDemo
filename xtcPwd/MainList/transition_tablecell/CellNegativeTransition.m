//
//  CellNegativeTransition.m
//  xtcPwd
//
//  Created by teason23 on 2017/12/25.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "CellNegativeTransition.h"
#import "PwdListController.h"
#import "DetailViewController.h"
#import "ListCell.h"
#import "UIColor+AllColors.h"
#import "DetailCollectionCell.h"

@implementation CellNegativeTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //获取动画前后两个VC 和 发生的容器containerView
    PwdListController *toVC = (PwdListController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] ;
    DetailViewController *fromVC = (DetailViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] ;
    UIView *containerView = [transitionContext containerView] ;
    
    DetailCollectionCell *currentCell = (DetailCollectionCell *)[fromVC.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:fromVC.currentIndex inSection:0]] ;
    
    //在前一个VC上创建一个截图
    UIView *snapShotView = [currentCell.image snapshotViewAfterScreenUpdates:NO] ;
    snapShotView.backgroundColor = [UIColor clearColor] ;
    snapShotView.frame = [containerView convertRect:currentCell.image.frame fromView:currentCell.image.superview] ;
    currentCell.image.hidden = YES ;
    
    //初始化后一个VC的位置
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC] ;
    
    //获取toVC中图片的位置
    ListCell *lCell = (ListCell *)[toVC.table cellForRowAtIndexPath:[toVC.table indexPathForSelectedRow]] ;
    lCell.image.hidden = YES ;
    
    //顺序很重要，
    [containerView insertSubview:toVC.view belowSubview:fromVC.view] ;
    [containerView addSubview:snapShotView] ;
    
    //发生动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         fromVC.view.alpha = 0.0f;
                         snapShotView.frame = toVC.finalCellRect;
                     } completion:^(BOOL finished) {
                         [snapShotView removeFromSuperview] ;
                         currentCell.image.hidden = NO ;
                         lCell.image.hidden = NO ;
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }] ;
}


@end
