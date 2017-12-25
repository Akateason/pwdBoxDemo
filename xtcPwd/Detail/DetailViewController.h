//
//  DetailViewController.h
//  xtcPwd
//
//  Created by teason23 on 2017/6/13.
//  Copyright © 2017年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PwdItem ;
@interface DetailViewController : UIViewController
@property (nonatomic,strong) PwdItem *item ;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@end
