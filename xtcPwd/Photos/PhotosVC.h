//
//  PhotosVC.h
//  xtcPwd
//
//  Created by xtc on 2018/2/6.
//  Copyright © 2018年 teason. All rights reserved.
//

#import "RootCtrl.h"
@class PwdItem,RACReplaySubject ;

@interface PhotosVC : RootCtrl
@property (strong, nonatomic) PwdItem *item ;
@property (strong, nonatomic) RACReplaySubject *subject ;
@property (copy, nonatomic) NSString *mainUrlString ;

@end
