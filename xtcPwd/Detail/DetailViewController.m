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
#import "XTDrawerFlowLayout.h"


@interface DetailViewController () <UINavigationControllerDelegate,iCarouselDataSource,iCarouselDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editItem;
@property (strong, nonatomic) iCarousel *carousel ;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentDrivenTransition;
@property (assign, nonatomic) NSInteger indexSended ;
@property (copy, nonatomic)   NSArray   *dataSource ;
@end

@implementation DetailViewController

#pragma mark - action

- (IBAction)editOnClick:(id)sender {
    [self performSegueWithIdentifier:@"detail2edit" sender:self.dataSource[self.carousel.currentItemIndex]] ;
}

- (void)selectedIndexInHomeList:(NSInteger)index
                           list:(NSArray *)list
{
    self.dataSource = [list copy] ;
    self.indexSended = index ;
}

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    [self setupUI] ;
    [self setupCarousel] ;
}

- (void)setupCarousel {
    self.carousel = [[iCarousel alloc] init] ;
    _carousel.backgroundColor = [UIColor xt_bg] ;
    _carousel.dataSource = self ;
    _carousel.delegate = self ;
    _carousel.type = iCarouselTypeRotary ;
    _carousel.pagingEnabled = YES ;
    _carousel.vertical = YES ;
    _carousel.scrollSpeed = 1.2 ;
    _carousel.decelerationRate = .6 ;
    [self.view addSubview:_carousel] ;
    [_carousel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view) ;
        make.bottom.equalTo(@(- APP_SAFEAREA_TABBAR_FLEX)) ;
        make.left.right.equalTo(self.view) ;
    }] ;
    
    [self.carousel scrollToItemAtIndex:self.indexSended animated:NO] ;
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
    
    PwdItem *currentItem = self.dataSource[self.carousel.currentItemIndex] ;
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
                          
                          [self.carousel reloadData] ;
//                          [_image sd_setImageWithURL:[NSURL URLWithString:self.item.imageUrl]] ;
                          [self.delegate oneItemUpdated:currentItem] ;
                      }] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - carousel

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.dataSource.count ;
}

static const float kFlexOfSide = 0 ;

- (UIView *)carousel:(iCarousel *)carousel
  viewForItemAtIndex:(NSInteger)index
         reusingView:(nullable UIView *)view
{
    DetailCollectionCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailCollectionCell" owner:self options:nil] lastObject] ;
    cell.item = self.dataSource[index] ;
    
    cell.frame = (CGRect) {
        CGPointZero,
        CGSizeMake(
                   APP_WIDTH - kFlexOfSide ,
                   APP_HEIGHT - APP_NAVIGATIONBAR_HEIGHT - APP_STATUSBAR_HEIGHT - APP_SAFEAREA_TABBAR_FLEX - kFlexOfSide
                   )
    } ;
    return cell ;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    PwdItem *item = self.dataSource[carousel.currentItemIndex] ;
    self.title = item.name ;
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
