//
//  DetailCollectionCell.h
//  xtcPwd
//
//  Created by xtc on 2018/2/2.
//  Copyright © 2018年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PwdItem ;

@interface DetailCollectionCell : UICollectionViewCell

@property (strong, nonatomic) PwdItem *item ;

@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbAccount;
@property (weak, nonatomic) IBOutlet UILabel *lbPwd;
@property (weak, nonatomic) IBOutlet UILabel *lbDetail;
@property (weak, nonatomic) IBOutlet UIButton *btCopy;
@property (weak, nonatomic) IBOutlet UIButton *btShow;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *image ;

@end
