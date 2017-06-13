//
//  ListCell.m
//  xtcPwd
//
//  Created by teason23 on 2017/6/13.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "ListCell.h"
#import "UIColor+AllColors.h"

@implementation ListCell

+ (CGFloat)cellHeight { return 52.f ; }

- (void)awakeFromNib
{
    [super awakeFromNib] ;
    // Initialization code
    self.backgroundColor = [UIColor clearColor] ;
    self.selectionStyle = 0 ;
    self.backView.backgroundColor = [UIColor xt_light] ;
    self.backView.layer.cornerRadius = 5 ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
