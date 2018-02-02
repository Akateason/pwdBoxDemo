//
//  ScreenHeader.h
//  XTkit
//
//  Created by teason on 2017/4/19.
//  Copyright © 2017年 teason. All rights reserved.

#ifndef ScreenHeader_h
#define ScreenHeader_h

#import "ScreenFit.h"
#import "UIColor+HexString.h"
#import "DeviceSysHeader.h"

// rate
#define rateH                           [[ScreenFit sharedInstance] getScreenHeightscale]
#define rateW                           [[ScreenFit sharedInstance] getScreenWidthscale]

// phone
#define APPFRAME                        [UIScreen mainScreen].bounds
#define APP_WIDTH                       CGRectGetWidth(APPFRAME)
#define APP_HEIGHT                      CGRectGetHeight(APPFRAME)
#define APP_NAVIGATIONBAR_HEIGHT        44.f
#define APP_STATUSBAR_HEIGHT            ( XT_IS_IPHONE_X ? APP_SAFEAREA_STATUSBAR_FLEX + 20. : 20. )
#define APP_TABBAR_HEIGHT               ( XT_IS_IPHONE_X ? 49.f + APP_SAFEAREA_TABBAR_FLEX : 49.f )
#define APP_SAFEAREA_STATUSBAR_FLEX     24.
#define APP_SAFEAREA_TABBAR_FLEX        ( XT_IS_IPHONE_X ? 43. : 0 )

// screen
#define G_ONE_PIXEL                     0.5f
#define G_CORNER_RADIUS                 6.0f

// color
#define UIColorRGBA(r, g, b, a)         [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define UIColorRGB(r, g, b)             UIColorRGBA(r, g, b, 1.0)
#define UIColorHex(X)                   [UIColor colorWithHexString:X]
#define UIColorHexA(X,a)                [UIColor colorWithHexString:X alpha:a]

// font
#define Font(F)                         [UIFont systemFontOfSize:(F)]
#define boldFont(F)                     [UIFont boldSystemFontOfSize:(F)]

#endif /* ScreenHeader_h */



