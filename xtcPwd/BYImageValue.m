//
//  BYImageValue.m
//  xtcPwd
//
//  Created by xtc on 2018/2/1.
//  Copyright © 2018年 teason. All rights reserved.
//

#import "BYImageValue.h"

@implementation BYImageValue

- (float)rateH2W {
    _rateH2W = (float)((float)_height / (float)_width) ;
    return _rateH2W ;
}

@end
