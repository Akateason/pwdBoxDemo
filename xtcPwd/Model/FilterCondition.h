//
//  FilterCondition.h
//  xtcPwd
//
//  Created by teason23 on 2017/12/27.
//  Copyright © 2017年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PwdItem.h"

typedef NS_ENUM(NSUInteger, SortByType) {
    sortByType_spell = 0 ,
    sortByType_time ,
    sortByType_read ,
};

@interface FilterCondition : NSObject

@property (nonatomic) TypeOfPwdItem filterCate  ;

@property (nonatomic) BOOL          isAscOrDesc ; // 1 ASC 0 DESC   // default 1.
@property (nonatomic) SortByType    sortByType  ;

+ (instancetype)sharedSingleton ;
- (void)setup ;
- (void)setupWithSortCate:(TypeOfPwdItem)cate
                ascOrDesc:(BOOL)ascOrDesc
               sortByType:(SortByType)type ;

@end
