//
//  PhotosVC.m
//  xtcPwd
//
//  Created by xtc on 2018/2/6.
//  Copyright © 2018年 teason. All rights reserved.
//

#import "PhotosVC.h"
#import "PhotoCollectionCell.h"
#import "ReqUtil.h"
#import "PwdItem.h"
#import "BYImageValue.h"
#import "RootCollectionView.h"

@interface PhotosVC () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,RootCollectionViewDelegate>
@property (copy, nonatomic) NSArray *datasource ;
@end

@implementation PhotosVC

#pragma mark - life

static const float kCellLine    = 1. ;
static const int   kCollumNum   = 2  ;

- (void)prepareUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init] ;
    layout.itemSize = CGSizeMake( [self.class itemWid] , 100) ;
    layout.minimumLineSpacing = kCellLine ;
    layout.minimumInteritemSpacing = kCellLine ;
    self.collectionView.collectionViewLayout = layout ;
    self.collectionView.dataSource = self ;
    self.collectionView.delegate = self ;
    self.collectionView.xt_Delegate = self ;
    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCollectionCell"] ;
    [self.collectionView loadNewInfo] ;
}

+ (float)itemWid {
    return (APP_WIDTH - (kCollumNum - 1) * kCellLine) / kCollumNum ;
}

- (void)viewDidLoad {
    [super viewDidLoad] ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - RootCollectionViewDelegate <NSObject>

static int kPageSize = 20 ;
static int kPage = 0  ;

- (void)collectionView:(RootCollectionView *)collection loadNew:(void(^)(void))endRefresh
{
    kPage = 0 ;
    [ReqUtil searchImageWithName:self.item.name
                           count:kPageSize
                          offset:kPage
                      completion:^(NSArray *list) {
                          
                          _datasource = [list copy] ;
                          
                          endRefresh() ;
                      }] ;
}

- (void)collectionView:(RootCollectionView *)collection loadMore:(void(^)(void))endRefresh
{
    kPage ++ ;
    [ReqUtil searchImageWithName:self.item.name
                           count:kPageSize
                          offset:kPage
                      completion:^(NSArray *list) {
                          
                          NSMutableArray *tmplist = [_datasource mutableCopy] ;
                          [tmplist addObjectsFromArray:list] ;
                          _datasource = [tmplist copy] ;
                          
                          endRefresh() ;
                      }] ;

}

#pragma mark - UICollectionViewDataSource <NSObject>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datasource.count ;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionCell" forIndexPath:indexPath] ;
    cell.imgVal = self.datasource[indexPath.row] ;
    return cell ;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BYImageValue *imageVal = self.datasource[indexPath.row] ;
    return CGSizeMake([self.class itemWid], [self.class itemWid] * imageVal.rateH2W) ;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
