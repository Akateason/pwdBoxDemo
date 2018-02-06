//
//  PwdTableViewHandler.h
//  xtcPwd
//
//  Created by xtc on 2018/2/6.
//  Copyright © 2018年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PwdListController ,UITableView ;
#import <UIKit/UITableView.h>

@interface PwdTableViewHandler : NSObject <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

- (instancetype)initWithCtrller:(PwdListController *)fromCtrller ;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath ;

@end
