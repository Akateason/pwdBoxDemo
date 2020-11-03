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
#import "XTColor+MyColors.h"
#import "SVProgressHUD.h"
#import "CellNegativeTransition.h"
#import "PwdListController.h"
#import <UINavigationController+FDFullscreenPopGesture.h>
#import "ReqUtil.h"
#import "BYImageValue.h"
#import <ReactiveObjC.h>
#import "DetailCollectionCell.h"
#import "HJCarouselViewLayout.h"
#import <XTTable/XTCollection.h>

@interface DetailViewController () <UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editItem ;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentDrivenTransition;

@property (copy, nonatomic)   NSArray   *dataSource ;
@property (assign, nonatomic) BOOL viewDidAppearDone ;
@end

@implementation DetailViewController

#pragma mark - util

- (void)selectedIndexInHomeList:(NSInteger)index
                           list:(NSArray *)list
{
    self.dataSource = [list copy] ;
    self.sendIndex = index ;
}

#pragma mark - prop

- (NSInteger)currentIndex {
    return self.collectionView.xt_currentIndexPath.row ;
}

#pragma mark - life

- (IBAction)editAction:(id)sender {
    [self performSegueWithIdentifier:@"detail2edit" sender:self.dataSource[self.currentIndex]] ;
}

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    [self setupUI] ;
    [self setupCarousel] ;
    
    @weakify(self)
    [[[NSNotificationCenter defaultCenter]
      rac_addObserverForName:@"NoteEditDone" object:nil]
     subscribeNext:^(NSNotification * _Nullable noti) {
         @strongify(self)
         PwdItem *item = noti.object ;
         NSMutableArray *tmplist = [self.dataSource mutableCopy] ;
         [self.dataSource enumerateObjectsUsingBlock:^(PwdItem *aItem, NSUInteger idx, BOOL * _Nonnull stop) {
             if (aItem.pkid == item.pkid) {
                 [tmplist replaceObjectAtIndex:idx withObject:item] ;
                 self.dataSource = tmplist ;
                 [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]]] ;
                 *stop = YES ;
             }
         }] ;
     }] ;
}

static const float kFlexOfSide = 0 ;

- (void)setupCarousel {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init] ;
    layout.itemSize = CGSizeMake(
                         APP_WIDTH - kFlexOfSide ,
                         APP_HEIGHT - APP_NAVIGATIONBAR_HEIGHT - APP_STATUSBAR_HEIGHT - APP_SAFEAREA_TABBAR_FLEX - kFlexOfSide
                                 ) ;
    [self.collectionView registerNib:[UINib nibWithNibName:@"DetailCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"DetailCollectionCell"] ;
    self.collectionView.collectionViewLayout = layout ;
    self.collectionView.dataSource = self ;
    self.collectionView.delegate = self ;
    self.collectionView.backgroundColor = [XTColor xt_bg] ;
    self.collectionView.collectionViewLayout = layout ;
    [self.collectionView setNeedsLayout] ;
    [self.collectionView layoutIfNeeded] ;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.sendIndex inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                        animated:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        HJCarouselViewLayout *clayout = [[HJCarouselViewLayout alloc] initWithAnim:HJCarouselAnimCarousel1] ;
        clayout.visibleCount = 3 ;
        clayout.itemSize = CGSizeMake(
                                      APP_WIDTH - kFlexOfSide ,
                                      APP_HEIGHT - APP_NAVIGATIONBAR_HEIGHT - APP_STATUSBAR_HEIGHT - APP_SAFEAREA_TABBAR_FLEX - kFlexOfSide
                                      ) ;
        self.collectionView.collectionViewLayout = clayout ;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.sendIndex inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                            animated:NO];
    });
    
    @weakify(self)
    [[[RACObserve(self.collectionView, contentOffset) filter:^BOOL(id  _Nullable value) {
        return self.viewDidAppearDone ;
    }]
      throttle:.8]
     subscribeNext:^(id  _Nullable x) {
         @strongify(self)
         PwdItem *currentItem = self.dataSource[self.currentIndex] ;
         self.title = currentItem.name ;
     }] ;
}

- (void)setupUI {
    // fd
    self.fd_interactivePopDisabled = YES ;
    // gesture
    self.navigationController.delegate = self ;
    UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePanGestureAction:)] ;
    edgePanGestureRecognizer.edges = UIRectEdgeLeft ;
    [self.view addGestureRecognizer:edgePanGestureRecognizer] ;
    
    self.view.backgroundColor = [XTColor xt_main];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    
    PwdItem *currentItem = self.dataSource[self.sendIndex] ;
    self.title = currentItem.name ;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.viewDidAppearDone = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count ;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailCollectionCell" forIndexPath:indexPath] ;
    cell.item = self.dataSource[indexPath.row] ; ;
    cell.indexPath = indexPath ;
    return cell ;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *curIndexPath = [collectionView xt_currentIndexPath] ;
    if (indexPath.row == curIndexPath.row) return YES ;
    
    [self.collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                        animated:YES] ;
    return NO ;
}

#pragma mark - gesture action

- (void)edgePanGestureAction:(UIScreenEdgePanGestureRecognizer *)recognizer {
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
