//
//  ReqUtil.h
//  xtcPwd
//
//  Created by xtc on 2018/2/1.
//  Copyright © 2018年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XTReq.h"

@interface ReqUtil : NSObject

+ (void)searchImageWithName:(NSString *)name
                      count:(int)count
                     offset:(int)offset
                 completion:(void (^)(NSArray *list))returnImages ;

@end
