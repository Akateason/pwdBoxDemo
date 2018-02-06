//
//  PwdListController.h
//  xtcPwd
//
//  Created by teason23 on 2017/6/13.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "RootCtrl.h"
@class PwdItem ;

@interface PwdListController : RootCtrl

@property (weak, nonatomic) IBOutlet UIButton *btSearch ;
@property (weak, nonatomic) IBOutlet UIButton *btUser ;
@property (weak, nonatomic, readonly) IBOutlet RootTableView *table ;
@property (weak, nonatomic, readonly) IBOutlet UIButton *btAdd;
@property (nonatomic,copy, readonly) NSArray *dataList ;
@property (nonatomic,assign) CGRect finalCellRect ;

@end
