//
//  EditViewController.h
//  xtcPwd
//
//  Created by teason23 on 2017/6/13.
//  Copyright © 2017年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PwdItem ;

@interface EditViewController : UIViewController
@property (nonatomic)           int             typeWillBeAdd   ; // add mode .
@property (nonatomic,strong)    PwdItem         *itemWillBeEdit ; // edit mode .
@end
