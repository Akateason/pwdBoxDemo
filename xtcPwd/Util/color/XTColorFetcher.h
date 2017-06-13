//
//  XTColorFetcher.h
//  pro
//
//  Created by TuTu on 16/8/16.
//  Copyright © 2016年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

// .h
#define AS_SINGLETON(__class) \
+(__class *)sharedInstance;

// .m
#define DEF_SINGLETON(__class)                                              \
+(__class *)sharedInstance                                              \
{                                                                        \
static dispatch_once_t once;                                        \
static __class *__singleton__;                                      \
dispatch_once(&once, ^{ __singleton__ = [[__class alloc] init]; }); \
return __singleton__;                                               \
}


#define XTCOLOR( _colorInPlist_ )     [[XTColorFetcher sharedInstance] xt_colorWithKey:_colorInPlist_]


@interface XTColorFetcher : NSObject

AS_SINGLETON(XTColorFetcher)

- (UIColor *)xt_colorWithKey:(NSString *)key ;

@end
