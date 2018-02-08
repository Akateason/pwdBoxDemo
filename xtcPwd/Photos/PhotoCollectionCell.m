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
#import "ScreenHeader.h"
#import "UIColor+AllColors.h"
#import "UIImage+AddFunction.h"

@implementation PhotoCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib] ;
    
    self.layer.cornerRadius = 15. ;
    self.imageView.layer.cornerRadius = 15. ;
    self.imageView.layer.masksToBounds = YES ;
    self.imageView.layer.borderWidth = .5 ;
    self.imageView.layer.borderColor = [UIColor xt_text_light].CGColor ;
    self.backgroundColor = [UIColor whiteColor] ;
//    self.layer.borderWidth = 1. ;
//    self.layer.borderColor = [UIColor xt_text_dark].CGColor ;
    self.label.textColor = [UIColor xt_text_light] ;
    self.addP.layer.cornerRadius = 15. / 2. ;
    self.addP.layer.borderColor = [UIColor whiteColor].CGColor ;
    self.addP.layer.borderWidth = 3 ;

    self.addP.image = [self.addP.image imageWithTintColor:[UIColor xt_main]] ;
//    self.addP.layer.masksToBounds = YES ;
}

- (void)setImgVal:(BYImageValue *)imgVal {
    _imgVal = imgVal ;
    
    _label.text = imgVal.name ;
    [_label sizeToFit] ;
    _wid.constant = [self.class itemWid] ;
    _hei.constant = [self.class itemWid] * imgVal.rateH2W ;
    
    if (imgVal.contentUrl.length) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:imgVal.thumbnailUrl]] ;
    }
}

+ (float)itemWid {
    return ( APP_WIDTH - (kCollumNum * 2 + 1) * kCellLine ) / kCollumNum ;
}

+ (CGSize)itemSizeWithItem:(BYImageValue *)imgVal {
    CGFloat imageW = [self itemWid] - 8. * 2. ;
    CGFloat imageH = imageW * imgVal.rateH2W ;
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy] ;
    style.lineBreakMode = NSLineBreakByWordWrapping ;
    style.alignment = NSTextAlignmentLeft ;
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:imgVal.name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:style}] ;
    CGSize size =  [string boundingRectWithSize:CGSizeMake(imageW, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size ;
    NSLog(@" size =  %@", NSStringFromCGSize(size));
    
    // 并不是高度计算不对，我估计是计算出来的数据是 小数，在应用到布局的时候稍微差一点点就不能保证按照计算时那样排列，所以为了确保布局按照我们计算的数据来，就在原来计算的基础上 取ceil值，再加1；
    CGFloat labelH = size.height ;
    
    return CGSizeMake([self itemWid] ,
                      imageH + labelH + 8. * 3.) ;
}

@end
