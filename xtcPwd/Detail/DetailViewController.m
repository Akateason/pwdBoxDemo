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
#import "ReqUtil.h"
#import "BYImageValue.h"
#import <ReactiveObjC.h>
#import "DetailCollectionCell.h"

@interface DetailViewController () <UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editItem;
@property (weak, nonatomic, readwrite) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentDrivenTransition;
@end

@implementation DetailViewController

#pragma mark - action

- (IBAction)editOnClick:(id)sender
{
    [self performSegueWithIdentifier:@"detail2edit" sender:self.item] ;
}


#pragma mark - life

- (void)viewDidLoad
{
    [super viewDidLoad] ;
    
    [self setupUI] ;
    
    self.collectionView.dataSource = self ;
    self.collectionView.delegate = self ;
    [self.collectionView registerNib:[UINib nibWithNibName:@"DetailCollectionCell" bundle:nil]
          forCellWithReuseIdentifier:@"DetailCollectionCell"] ;
    self.collectionView.backgroundColor = [UIColor xt_bg] ;
    self.collectionView.pagingEnabled = YES ;

    if (!self.item) return ;
}

- (void)setupUI {
    self.fd_interactivePopDisabled = YES ;
    
    self.navigationController.delegate = self ;
    // 滑动手势 控制比例的pop动作
    UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePanGestureAction:)] ;
    edgePanGestureRecognizer.edges = UIRectEdgeLeft ;
    [self.view addGestureRecognizer:edgePanGestureRecognizer] ;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    self.title = self.item.name ;
    if (self.item.imageUrl.length) {
        return ;
    }
    
    @weakify(self)
    [ReqUtil searchImageWithName:self.item.name
                           count:1
                          offset:0
                      completion:^(NSArray *list) {
                          @strongify(self)
                          if (!list) return ;
                          
                          BYImageValue *imageValue = [list firstObject] ;
                          self.item.imageUrl = imageValue.thumbnailUrl ;
                          [self.item update] ;
                          
                          [self.collectionView reloadData] ;
//                          [_image sd_setImageWithURL:[NSURL URLWithString:self.item.imageUrl]] ;
                          [self.delegate oneItemUpdated:self.item] ;
                      }] ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3 ;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailCollectionCell"
                                                                           forIndexPath:indexPath] ;
    cell.item = self.item ;
    return cell ;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(APP_WIDTH ,
                      APP_HEIGHT - APP_NAVIGATIONBAR_HEIGHT - APP_STATUSBAR_HEIGHT) ;
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
