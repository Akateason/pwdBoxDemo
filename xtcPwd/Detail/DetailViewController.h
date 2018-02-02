//
//  DetailViewController.h
//  xtcPwd
//
//  Created by teason23 on 2017/6/13.
//  Copyright © 2017年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PwdItem ;

@protocol DetailViewControllerDelegate <NSObject>
- (void)oneItemUpdated:(PwdItem *)aItem ;
@end

@interface DetailViewController : UIViewController
@property (weak,nonatomic) id <DetailViewControllerDelegate> delegate ;
@property (nonatomic,strong) PwdItem *item ;
@property (weak, nonatomic, readonly) IBOutlet UICollectionView *collectionView;
@end
