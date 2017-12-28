//
//  AddVC.m
//  xtcPwd
//
//  Created by teason23 on 2017/12/27.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "AddVC.h"
#import "PwdItem.h"
#import "EditViewController.h"
#import <ReactiveObjC.h>
#import "AddTransition.h"
#import "PresentController.h"

@interface AddVC () <UIViewControllerTransitioningDelegate>
{
    UIPercentDrivenInteractiveTransition *percentDrivenInteractiveTransition;
}
@property (weak, nonatomic) IBOutlet UIButton *btCancel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *bts;
@end

@implementation AddVC

#pragma mark - action

- (IBAction)btCancelOnClick:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil] ;
}

- (IBAction)addActionOnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 if ([sender.currentTitle containsString:@"Web"]) {
                                     [self.delegate addPwdItem:typeWebsite] ;
                                 }
                                 else {
                                     [self.delegate addPwdItem:typeCard] ;
                                 }
                             }] ;

}

#pragma mark - life

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom ;
        self.transitioningDelegate  = self ;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    for (UIButton *bt in _bts) {
        bt.layer.cornerRadius = 4. ;
    }
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes:)];
    [self.view addGestureRecognizer:pan];
}


- (void)panGes:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:self.view] ;
    CGFloat yOffset = translation.y ;
    float percent = yOffset / 1800. ;
    if (percent < 0) return ;
//    NSLog(@"per : %@",@(percent)) ;

    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        percentDrivenInteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init] ;
        //这句必须加上！！
        [self dismissViewControllerAnimated:YES
                                 completion:nil] ;
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        [percentDrivenInteractiveTransition updateInteractiveTransition:percent] ;
    }
    else if (gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateEnded)
    {
        [percentDrivenInteractiveTransition finishInteractiveTransition] ;
        //这句也必须加上！！
        percentDrivenInteractiveTransition = nil ;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UIViewControllerTransitioningDelegate>

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source
{
    PresentController *presentation = [[PresentController alloc] initWithPresentedViewController:presented
                                                                        presentingViewController:presenting] ;
    return presentation;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source
{
    AddTransition *present = [[AddTransition alloc] initWithBool:YES] ;
    return present ;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    if (dismissed) {
        AddTransition *present = [[AddTransition alloc] initWithBool:NO] ;
        return present ;
    }
    else {
        return nil ;
    }
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    if (animator) {
        return percentDrivenInteractiveTransition ;
    }
    else {
        return nil ;
    }
}


/*
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}
*/

@end
