//
//  BaiduWebVC.h
//  xtcPwd
//
//  Created by teason23 on 2018/12/19.
//  Copyright © 2018 teason. All rights reserved.
//

#import <RootCtrl.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaiduWebVC : UIViewController

+ (instancetype)newWithSchName:(NSString *)search
                 photoSelected:(void(^)(NSString *imgUrlStr))blkPhotoSelected ;

@end

NS_ASSUME_NONNULL_END
