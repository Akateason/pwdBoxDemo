//
//  LoginVC.h
//  xtcPwd
//
//  Created by teason23 on 2019/11/15.
//  Copyright © 2019 teason. All rights reserved.
//

#import "RootCtrl.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginVC : RootCtrl
    @property (weak, nonatomic) IBOutlet UILabel *lbTitle;
    @property (weak, nonatomic) IBOutlet UITextField *tfPhone;
    @property (weak, nonatomic) IBOutlet UIView *linePhone;
    @property (weak, nonatomic) IBOutlet UITextField *tfCode;
    @property (weak, nonatomic) IBOutlet UIView *lineCode;
    @property (weak, nonatomic) IBOutlet UIButton *btVerify;
    
    
    
    
@end

NS_ASSUME_NONNULL_END
