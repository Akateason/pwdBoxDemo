//
//  PhotoCollectionCell.h
//  xtcPwd
//
//  Created by xtc on 2018/2/6.
//  Copyright © 2018年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BYImageValue ;

@interface PhotoCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) BYImageValue *imgVal ;
@end
