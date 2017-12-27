//
//  DetailViewController.m
//  xtcPwd
//
//  Created by teason23 on 2017/6/13.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "DetailViewController.h"
#import "EditViewController.h"
#import "PwdItem.h"
#import "UIColor+AllColors.h"
#import "SVProgressHUD.h"
#import "CellNegativeTransition.h"
#import "PwdListController.h"
#import <UINavigationController+FDFullscreenPopGesture.h>

@interface DetailViewController () <UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbAccount;
@property (weak, nonatomic) IBOutlet UILabel *lbPwd;
@property (weak, nonatomic) IBOutlet UILabel *lbDetail;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editItem;
@property (weak, nonatomic) IBOutlet UIButton *btCopy;
@property (weak, nonatomic) IBOutlet UIButton *btShow;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentDrivenTransition;
@end

@implementation DetailViewController

#pragma mark -

- (IBAction)editOnClick:(id)sender
{
    [self performSegueWithIdentifier:@"detail2edit" sender:self.item] ;
}

- (IBAction)copyOnClick:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard] ;
    pasteboard.string = [self.item decodePwd] ;
    [SVProgressHUD showInfoWithStatus:@"Already Copied To The Clipboard"] ;
}

- (IBAction)showOnClick:(id)sender
{
    _lbPwd.text = [self.item decodePwd] ;
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad] ;
    
    self.fd_interactivePopDisabled = YES ;

    self.navigationController.delegate = self ;
    // 滑动手势 控制比例的pop动作
    UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePanGestureAction:)] ;
    edgePanGestureRecognizer.edges = UIRectEdgeLeft ;
    [self.view addGestureRecognizer:edgePanGestureRecognizer] ;
    
    self.view.backgroundColor = [UIColor whiteColor] ; //[UIColor xt_bg] ;
    
    UIColor *wordsColor = [UIColor xt_text_dark] ;
    _lbName.textColor = wordsColor ;
    _lbAccount.textColor = wordsColor ;
    _lbPwd.textColor = wordsColor ;
    _lbDetail.textColor = wordsColor ;
    
    [_btCopy setTitleColor:[UIColor whiteColor] forState:0] ;
    [_btShow setTitleColor:[UIColor whiteColor] forState:0] ;
    _btCopy.layer.cornerRadius = 5. ;
    _btShow.layer.cornerRadius = 5. ;
    _btCopy.backgroundColor = [UIColor xt_main] ;
    _btShow.backgroundColor = [UIColor xt_main] ;
    
    self.image.layer.cornerRadius = self.image.frame.size.width / 6. ;
    self.image.layer.masksToBounds = YES ;
    
    if (!self.item) return ;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    // fetch from db .
    self.item = [PwdItem findFirstWhere:[NSString stringWithFormat:@"pkid == %d",self.item.pkid]] ;
    
    _lbName.text = self.item.name ;
    _lbAccount.text = self.item.account ;
    _lbPwd.text = [self makePwdHidden] ;
    _lbDetail.text = self.item.detailInfo ;
    
    self.title = self.item.name ;
    
    self.item.readCount ++ ;
    [self.item update] ;
}

- (NSString *)makePwdHidden
{
    int count = (int)[[self.item decodePwd] length] ;
    NSString *itemStr = @"*" ;
    NSMutableString *tmpStr = [@"" mutableCopy] ;
    for (int i = 0; i < count; i++) {
        [tmpStr appendString:itemStr] ;
    }
    return tmpStr ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - gesture action

- (void)edgePanGestureAction:(UIScreenEdgePanGestureRecognizer *)recognizer
{
    //计算手指滑的物理距离（滑了多远，与起始位置无关）
    CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width) ;
    progress = MIN(1.0, MAX(0.0, progress));//把这个百分比限制在0~1之间
    
    //当手势刚刚开始，我们创建一个 UIPercentDrivenInteractiveTransition 对象
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.percentDrivenTransition = [[UIPercentDrivenInteractiveTransition alloc] init] ;
        [self.navigationController popViewControllerAnimated:YES] ;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        //当手慢慢划入时，我们把总体手势划入的进度告诉 UIPercentDrivenInteractiveTransition 对象。
        [self.percentDrivenTransition updateInteractiveTransition:progress] ;
    }
    else if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded) {
        //当手势结束，我们根据用户的手势进度来判断过渡是应该完成还是取消并相应的调用 finishInteractiveTransition 或者 cancelInteractiveTransition 方法.
        if (progress > 0.3) {
            [self.percentDrivenTransition finishInteractiveTransition] ;
        }
        else {
            [self.percentDrivenTransition cancelInteractiveTransition] ;
        }
        self.percentDrivenTransition = nil ;
    }
}

#pragma mark - <UINavigationControllerDelegate>

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if ([toVC isKindOfClass:[PwdListController class]]) {
        return [CellNegativeTransition new] ;
    }
    else {
        return nil ;
    }
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    if ([animationController isKindOfClass:[CellNegativeTransition class]]) {
        return self.percentDrivenTransition ;
    }
    else {
        return nil;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detail2edit"]) {
        EditViewController *editVC = [segue destinationViewController] ;
        editVC.itemWillBeEdit = sender ;
    }
}

@end
