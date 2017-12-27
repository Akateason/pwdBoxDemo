//
//  AddVC.m
//  xtcPwd
//
//  Created by teason23 on 2017/12/27.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "AddVC.h"
#import "AddTransition.h"
#import "PresentController.h"
#import "PwdItem.h"
#import "EditViewController.h"
#import <ReactiveObjC.h>

@interface AddVC () <UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btCancel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *bts;

@end

@implementation AddVC

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom ;
        self.transitioningDelegate  = self ;
    }
    return self;
}

#pragma mark - action

- (IBAction)btCancelOnClick:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil] ;
}

- (IBAction)addActionOnClick:(UIButton *)sender {
    if ([sender.currentTitle containsString:@"Web"]) {
        [self performSegueWithIdentifier:@"add2edit" sender:@(typeWebsite)] ;
    }
    else {
        [self performSegueWithIdentifier:@"add2edit" sender:@(typeCard)] ;
    }
}


#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIButton *bt in _bts) {
        bt.layer.cornerRadius = 4. ;
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

//- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
//{
//    if (animator) {
//        return percentDrivenInteractiveTransition ;
//    }
//    else {
//        return nil ;
//    }
//}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"add2edit"]) {
        EditViewController *addVC = [segue destinationViewController] ;
        addVC.typeWillBeAdd = [sender intValue] ;
        @weakify(self)
        addVC.addItemSuccessBlock = ^{
            @strongify(self)
            [self refreshTable] ;
        } ;
    }
    
}


@end
