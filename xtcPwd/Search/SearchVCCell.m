//
//  SearchVCCell.m
//  xtcPwd
//
//  Created by teason23 on 2018/1/10.
//  Copyright © 2018年 teason. All rights reserved.
//

#import "SearchVCCell.h"
#import "UIColor+AllColors.h"
#import "PwdItem.h"

@implementation SearchVCCell

- (void)awakeFromNib {
    [super awakeFromNib] ;
}

- (void)prepareUI {
    self.backgroundColor = [UIColor xt_main] ;
    self.account.textColor = [UIColor colorWithWhite:1 alpha:.6] ;
}

+ (CGFloat)cellHeight {
    return 60. ;
}

- (void)configure:(PwdItem *)model {
    self.lbName.text = model.name ;
    self.account.text = model.account ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
