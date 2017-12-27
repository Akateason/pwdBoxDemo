//
//  UserViewController.h
//  xtcPwd
//
//  Created by teason23 on 2017/6/15.
//  Copyright © 2017年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FilterCondition ;

@protocol FilterDelegate <NSObject>
- (void)confirmWithFilter:(FilterCondition *)condition ;
@end

@interface UserViewController : UIViewController
@property (weak,nonatomic) id <FilterDelegate> delegate ;
@end
