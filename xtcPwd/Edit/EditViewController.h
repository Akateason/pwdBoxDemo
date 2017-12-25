//
//  EditViewController.h
//  xtcPwd
//
//  Created by teason23 on 2017/6/13.
//  Copyright © 2017年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PwdItem ;

typedef void(^AddItemSuccess)(void) ;

@interface EditViewController : UIViewController

@property (nonatomic)           int             typeWillBeAdd   ; // add mode .
@property (nonatomic,strong)    PwdItem         *itemWillBeEdit ; // edit mode .

@property (nonatomic,copy)      AddItemSuccess  addItemSuccessBlock ;

@end
