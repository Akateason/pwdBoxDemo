//
//  ListCell.m
//  xtcPwd
//
//  Created by teason23 on 2017/6/13.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "ListCell.h"
#import "UIColor+AllColors.h"
#import "PwdItem.h"

@implementation ListCell

+ (CGFloat)cellHeight { return 62.f ; }

- (void)prepare {
    self.backgroundColor = [UIColor xt_bg] ; // [UIColor clearColor] ;
    self.selectionStyle = 0 ;
    self.backView.backgroundColor = [UIColor whiteColor] ; // [UIColor xt_bg] ;
    self.backView.layer.cornerRadius = 5 ;
    self.name.textColor = [UIColor xt_text_dark] ;
    self.account.textColor = [UIColor xt_text_light] ;
    
    self.image.layer.cornerRadius = self.image.frame.size.width / 6. ;
    self.image.layer.masksToBounds = YES ;
}

- (void)configure:(PwdItem *)model {
    self.name.text = model.name ;
    self.account.text = model.account ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
