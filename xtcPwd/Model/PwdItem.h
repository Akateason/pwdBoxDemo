//
//  PwdItem.h
//  xtcPwd
//
//  Created by teason23 on 2017/6/13.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "XTDBModel.h"

typedef enum : NSUInteger {
    typeNone ,
    typeWebsite = 1 ,
    typeCard ,
} TypeOfPwdItem;

@interface PwdItem : XTDBModel

//ADD IN v1
@property (nonatomic,strong) NSString *name ;
@property (nonatomic,strong) NSString *account ;
@property (nonatomic,strong) NSString *password ;
@property (nonatomic,strong) NSString *detailInfo ;
@property (nonatomic)        int      typeOfPwdItem ;
//ADD IN v2
@property (nonatomic)        int      readCount ;

- (NSString *)encodePwd:(NSString *)password ;
- (NSString *)decodePwd ;

- (instancetype)initWithName:(NSString *)name
                     account:(NSString *)account
                    password:(NSString *)password
                      detail:(NSString *)detail
                        type:(TypeOfPwdItem)type ;

@end
