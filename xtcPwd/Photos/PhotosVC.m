//
//  PhotosVC.m
//  xtcPwd
//
//  Created by xtc on 2018/2/6.
//  Copyright © 2018年 teason. All rights reserved.
//

#import "PhotosVC.h"
#import "PhotoCollectionCell.h"

@interface PhotosVC () <UICollectionViewDataSource>

@end

@implementation PhotosVC

#pragma mark - life

static const float kCellLine = 1. ;

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init] ;
    layout.itemSize = CGSizeMake( (APP_WIDTH - 3 * kCellLine) / 4. , 100) ;
    layout.minimumLineSpacing = kCellLine ;
    layout.minimumInteritemSpacing = kCellLine ;
    
    self.collectionView.collectionViewLayout = layout ;
    self.collectionView.dataSource = self ;
    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCollectionCell"] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource <NSObject>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10 ;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionCell" forIndexPath:indexPath] ;
    return cell ;
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
