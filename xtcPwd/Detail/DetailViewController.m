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
#import "HJCarouselViewLayout.h"


@interface DetailViewController () <UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editItem ;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign, nonatomic) NSInteger sendIndex ;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentDrivenTransition;

@property (copy, nonatomic)   NSArray   *dataSource ;
@end

@implementation DetailViewController

#pragma mark - action

- (IBAction)editOnClick:(id)sender {
    [self performSegueWithIdentifier:@"detail2edit" sender:self.dataSource[self.currentIndex]] ;
}

- (void)selectedIndexInHomeList:(NSInteger)index
                           list:(NSArray *)list
{
    self.dataSource = [list copy] ;
    self.sendIndex = index ;
}

#pragma mark - prop

- (NSInteger)currentIndex {
    return [self curIndexPath].row ;
}

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    [self setupUI] ;
    [self setupCarousel] ;
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
    self.collectionView.backgroundColor = [UIColor xt_bg] ;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.sendIndex inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:NO] ;
}

- (void)setupUI {
    // fd
    self.fd_interactivePopDisabled = YES ;
    // gesture
    self.navigationController.delegate = self ;
    UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePanGestureAction:)] ;
    edgePanGestureRecognizer.edges = UIRectEdgeLeft ;
    [self.view addGestureRecognizer:edgePanGestureRecognizer] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    
    PwdItem *currentItem = self.dataSource[self.sendIndex] ;
    self.title = currentItem.name ;
    if (currentItem.imageUrl.length) return ;
    
    @weakify(self)
    [ReqUtil searchImageWithName:currentItem.name
                           count:1
                          offset:0
                      completion:^(NSArray *list) {
                          @strongify(self)
                          if (!list) return ;
                          
                          BYImageValue *imageValue = [list firstObject] ;
                          currentItem.imageUrl = imageValue.thumbnailUrl ;
                          [currentItem update] ;
                          
                          [self.collectionView reloadData] ;
//                          [_image sd_setImageWithURL:[NSURL URLWithString:self.item.imageUrl]] ;
                          [self.delegate oneItemUpdated:currentItem] ;
                      }] ;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated] ;
    
    HJCarouselViewLayout *layout = [[HJCarouselViewLayout alloc] initWithAnim:HJCarouselAnimCarousel1] ;
    layout.visibleCount = 3 ;
    layout.itemSize = CGSizeMake(
                                 APP_WIDTH - kFlexOfSide ,
                                 APP_HEIGHT - APP_NAVIGATIONBAR_HEIGHT - APP_STATUSBAR_HEIGHT - APP_SAFEAREA_TABBAR_FLEX - kFlexOfSide
                                 ) ;
    self.collectionView.collectionViewLayout = layout ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count ;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailCollectionCell" forIndexPath:indexPath] ;
    cell.item = self.dataSource[indexPath.row] ; ;
    cell.indexPath = indexPath ;
    return cell ;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *curIndexPath = [self curIndexPath] ;
    if (indexPath.row == curIndexPath.row) return YES ;
    
    [self.collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:YES] ;
    return NO ;
}

- (NSIndexPath *)curIndexPath {
    NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
    NSIndexPath *curIndexPath = nil;
    NSInteger curzIndex = 0;
    for (NSIndexPath *path in indexPaths.objectEnumerator) {
        UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:path];
        if (!curIndexPath) {
            curIndexPath = path;
            curzIndex = attributes.zIndex;
            continue;
        }
        if (attributes.zIndex > curzIndex) {
            curIndexPath = path;
            curzIndex = attributes.zIndex;
        }
    }
    return curIndexPath;
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
