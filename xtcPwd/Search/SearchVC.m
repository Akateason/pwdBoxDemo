//
//  SearchVC.m
//  
//
//  Created by teason23 on 2017/12/27.
//

#import "SearchVC.h"
#import <UINavigationController+FDFullscreenPopGesture.h>
#import "UIColor+AllColors.h"
#import "UIImage+AddFunction.h"
#import "SearchNegativeTransition.h"
#import "PwdListController.h"
#import "SearchVCCell.h"
#import "PwdItem.h"
#import "DetailViewController.h"

@interface SearchVC () <UINavigationControllerDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *searchClearButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTextfield;
@property (weak, nonatomic) IBOutlet UIImageView *imageClose;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topbarHeight;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentDrivenTransition;
@property (copy, nonatomic) NSArray *resultList ;
@end

@implementation SearchVC

- (IBAction)btClearOnClick:(id)sender {
    self.searchTextfield.text = @"" ;
    self.resultList = @[] ;
    [self.table reloadData] ;
}

#pragma mark - UITextFieldDelegate <NSObject>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"%@",textField.text) ;
    [textField resignFirstResponder] ;
    return YES ;
}

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultList.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchVCCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchVCCell"] ;
    [cell configure:self.resultList[indexPath.row]] ;
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SearchVCCell cellHeight] ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    
    [self.navigationController popViewControllerAnimated:YES] ;
    [self.delegate searchConfirmAndGoto:self.resultList[indexPath.row]] ;
}

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    [self setupUI] ;
    [self.searchTextfield becomeFirstResponder] ;
}

- (void)setupUI {
    [self.navigationController setNavigationBarHidden:YES animated:NO] ;
    self.fd_prefersNavigationBarHidden = YES ;
    self.fd_interactivePopDisabled = YES ;
    self.navigationController.delegate = self ;
    
    self.topbarHeight.constant = APP_NAVIGATIONBAR_HEIGHT + APP_STATUSBAR_HEIGHT ;
    self.view.backgroundColor = [UIColor xt_main] ;
    self.searchTextfield.delegate = self ;
    self.searchTextfield.textColor = [UIColor xt_text_dark] ;
    self.table.dataSource = self ;
    self.table.delegate = self ;
    self.table.backgroundColor = [UIColor xt_main] ;
    
    [self.searchTextfield addTarget:self action:@selector(tfTextChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.topBackView.backgroundColor = [UIColor xt_main] ;
    self.searchBackView.backgroundColor = [UIColor whiteColor] ;
    self.imageClose.image = [[UIImage imageNamed:@"close2"] imageWithTintColor:[UIColor xt_main]] ;
    self.imageClose.layer.cornerRadius = 10. ;
    self.imageClose.layer.masksToBounds = YES ;
    self.searchBackView.layer.cornerRadius = self.searchClearButton.frame.size.height / 2. ;
    
    // 滑动手势 控制比例的pop动作
    UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePanGestureAction:)] ;
    edgePanGestureRecognizer.edges = UIRectEdgeLeft ;
    [self.view addGestureRecognizer:edgePanGestureRecognizer] ;

}

- (void)tfTextChange:(UITextField *)textField {
    if (!textField.text.length) {
        self.resultList = @[] ;
        [self.table reloadData] ;
        return ;
    }
    
    NSArray *list = [PwdItem selectWhere:STR_FORMAT(@"name like '%%%@%%' or account like '%%%@%%' ;",textField.text,textField.text)] ;
    self.resultList = [list copy] ;
    [self.table reloadData] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UINavigationControllerDelegate>

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if ([toVC isKindOfClass:[PwdListController class]]) {
        return [SearchNegativeTransition new] ;
    }
    else {
        return nil ;
    }
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    if ([animationController isKindOfClass:[SearchNegativeTransition class]]) {
        return self.percentDrivenTransition ;
    }
    else {
        return nil;
    }
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

#pragma mark - Navigation



@end
