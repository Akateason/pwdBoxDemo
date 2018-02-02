//
//  DetailViewController.h
//  xtcPwd
//
//  Created by teason23 on 2017/6/13.
//  Copyright © 2017年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iCarousel.h>
@class PwdItem, iCarousel ;

@protocol DetailViewControllerDelegate <NSObject>
- (void)oneItemUpdated:(PwdItem *)aItem ;
@end

@interface DetailViewController : UIViewController
@property (weak,nonatomic) id <DetailViewControllerDelegate> delegate ;
@property (strong, nonatomic, readonly) iCarousel *carousel ;
- (void)selectedIndexInHomeList:(NSInteger)index list:(NSArray *)list ;
@end
