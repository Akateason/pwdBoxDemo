//
//  PhotoCollectionCell.m
//  xtcPwd
//
//  Created by xtc on 2018/2/6.
//  Copyright © 2018年 teason. All rights reserved.
//

#import "PhotoCollectionCell.h"
#import "BYImageValue.h"
#import <UIImageView+WebCache.h>

@implementation PhotoCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImgVal:(BYImageValue *)imgVal {
    _imgVal = imgVal ;
    
    if (imgVal.thumbnailUrl.length) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:imgVal.thumbnailUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            
        }] ;
    }
}

@end
