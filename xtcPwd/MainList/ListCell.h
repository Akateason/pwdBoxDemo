//
//  ListCell.h
//  xtcPwd
//
//  Created by teason23 on 2017/6/13.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "RootTableCell.h"

@interface ListCell : RootTableCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *account;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIView *backView;
@end
