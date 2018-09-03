//
//  DetailCollectionCell.m
//  xtcPwd
//
//  Created by xtc on 2018/2/2.
//  Copyright © 2018年 teason. All rights reserved.
//

#import "DetailCollectionCell.h"
#import "XTColor+MyColors.h"
#import <SVProgressHUD.h>
#import "PwdItem.h"
#import <UIImageView+WebCache.h>

@implementation DetailCollectionCell

- (IBAction)copyOnClick:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard] ;
    pasteboard.string = [self.item decodePwd] ;
    [SVProgressHUD showInfoWithStatus:@"Already Copied To The Clipboard"] ;
}

- (IBAction)showOnClick:(id)sender
{
    _lbPwd.text = [self.item decodePwd] ;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 5. ;
    
    self.backgroundColor = nil ;
    self.bgView.backgroundColor = [UIColor whiteColor] ;
    self.bgView.layer.cornerRadius = 5. ;
//    self.bgView.layer.borderWidth = .5 ;
//    self.bgView.layer.borderColor = [UIColor xt_text_light].CGColor ;
    
    UIColor *wordsColor = [XTColor xt_text_dark] ;
    _lbName.textColor = wordsColor ;
    _lbAccount.textColor = wordsColor ;
    _lbPwd.textColor = wordsColor ;
    _lbDetail.textColor = wordsColor ;

    [_btCopy setTitleColor:[UIColor whiteColor] forState:0] ;
    [_btShow setTitleColor:[UIColor whiteColor] forState:0] ;
    _btCopy.layer.cornerRadius = 5. ;
    _btShow.layer.cornerRadius = 5. ;
    _btCopy.backgroundColor = [XTColor xt_main] ;
    _btShow.backgroundColor = [XTColor xt_main] ;
    
    self.image.layer.cornerRadius = self.image.frame.size.width / 6. ;
    self.image.layer.masksToBounds = YES ;
    self.image.layer.borderWidth = .5 ;
    self.image.layer.borderColor = [XTColor xt_text_light].CGColor ;
}

- (void)setItem:(PwdItem *)item {
    _item = item ;
    
    // fetch from db .
    _item = [PwdItem findFirstWhere:[NSString stringWithFormat:@"pkid == %d",item.pkid]] ;
    
    _lbName.text = self.item.name ;
    _lbAccount.text = self.item.account ;
    _lbPwd.text = [self makePwdHidden] ;
    _lbDetail.text = self.item.detailInfo ;
    [_image sd_setImageWithURL:[NSURL URLWithString:self.item.imageUrl]
              placeholderImage:[UIImage imageNamed:@"logo"]] ;
    
    _item.readCount ++ ;
    [_item update] ;
}

- (NSString *)makePwdHidden {
    int count = (int)[[self.item decodePwd] length] ;
    NSString *itemStr = @"*" ;
    NSMutableString *tmpStr = [@"" mutableCopy] ;
    for (int i = 0; i < count; i++) {
        [tmpStr appendString:itemStr] ;
    }
    return tmpStr ;
}

@end
