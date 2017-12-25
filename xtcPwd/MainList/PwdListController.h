//
//  PwdListController.h
//  xtcPwd
//
//  Created by teason23 on 2017/6/13.
//  Copyright © 2017年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PwdListController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btUser ;
@property (weak, nonatomic) IBOutlet UITableView *table ;
@property (nonatomic,assign) CGRect finalCellRect ;
@end
