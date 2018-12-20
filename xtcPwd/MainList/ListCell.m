//
//  ListCell.m
//  xtcPwd
//
//  Created by teason23 on 2017/6/13.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "ListCell.h"
#import "XTColor+MyColors.h"
#import "PwdItem.h"
#import <UIImageView+WebCache.h>
#import "UIImage+AddFunction.h"
#import <ReactiveObjC.h>

@implementation ListCell

+ (CGFloat)cellHeight { return 62.f ; }

- (void)prepareUI {
    self.backgroundColor = [XTColor xt_bg] ; // [UIColor clearColor] ;
    self.selectionStyle = 0 ;
    self.backView.backgroundColor = [UIColor whiteColor] ; // [UIColor xt_bg] ;
    self.backView.layer.cornerRadius = 5 ;
    self.name.textColor = [XTColor xt_text_dark] ;
    self.account.textColor = [XTColor xt_text_light] ;
    
    self.image.layer.cornerRadius = self.image.frame.size.width / 6. ;
    self.image.layer.masksToBounds = YES ;
//    self.image.layer.borderWidth = .5 ;
//    self.image.layer.borderColor = [UIColor xt_text_light].CGColor ;
}

#define GET_IMAGE_SIZE_SCALE2x(_size_)        CGSizeMake(_size_.width * 2., _size_.height * 2.)

- (void)configure:(PwdItem *)model
        indexPath:(NSIndexPath *)indexPath
{
    [super configure:model indexPath:indexPath] ;
    
    self.name.text = model.name ;
    self.account.text = model.account ;
    self.image.image = [UIImage imageNamed:@"logo"] ;
    if (model.imageUrl.length) {
        
        @weakify(self)
        [self.image sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]
                      placeholderImage:[UIImage imageNamed:@"logo"]
                             completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                
                                 @strongify(self)
                                 image = [UIImage thumbnailWithImage:image size:GET_IMAGE_SIZE_SCALE2x(self.image.frame.size)] ;
                                 self.image.image = image ;
                                 if (!image) {
                                     self.image.image = [UIImage imageNamed:@"logo"] ;
                                 }
                             }] ;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
