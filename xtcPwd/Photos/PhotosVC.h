//
//  PhotosVC.h
//  xtcPwd
//
//  Created by xtc on 2018/2/6.
//  Copyright © 2018年 teason. All rights reserved.
//

#import "RootCtrl.h"
@class PwdItem ;

@interface PhotosVC : RootCtrl
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIImage *imageSend ;
@property (strong, nonatomic) PwdItem *item ;
@end
