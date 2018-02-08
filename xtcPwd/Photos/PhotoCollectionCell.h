//
//  PhotoCollectionCell.h
//  xtcPwd
//
//  Created by xtc on 2018/2/6.
//  Copyright © 2018年 teason. All rights reserved.
//
static const float kCellLine    = 15. ;
static const int   kCollumNum   = 2  ;


#import <UIKit/UIKit.h>
@class BYImageValue ;

@interface PhotoCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wid;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hei;

@property (weak, nonatomic) IBOutlet UIImageView *addP;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) BYImageValue *imgVal ;

+ (float)itemWid ;
+ (CGSize)itemSizeWithItem:(BYImageValue *)imgVal ;

@end
