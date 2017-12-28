//
//  AddVC.h
//  xtcPwd
//
//  Created by teason23 on 2017/12/27.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "RootCtrl.h"
#import "PwdItem.h"

@protocol AddVCDelegate <NSObject>
- (void)addPwdItem:(TypeOfPwdItem)type ;
@end

@interface AddVC : RootCtrl
@property (weak,nonatomic) id <AddVCDelegate> delegate ;
@end
