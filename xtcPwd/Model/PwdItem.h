//
//  PwdItem.h
//  xtcPwd
//
//  Created by teason23 on 2017/6/13.
//  Copyright © 2017年 teason. All rights reserved.
//
#import <XTFMDB.h>
#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    typeNone ,
    typeWebsite = 1 ,
    typeCard ,
} TypeOfPwdItem;

@interface PwdItem : NSObject

//ADD IN v1
@property (nonatomic,copy)   NSString *name ;
@property (nonatomic,copy)   NSString *account ;
@property (nonatomic,copy)   NSString *password ;
@property (nonatomic,copy)   NSString *detailInfo ;
@property (nonatomic)        int      typeOfPwdItem ;
//ADD IN v2
@property (nonatomic)        int      readCount ;
@property (nonatomic,copy)   NSString *pinyin ;
//ADD IN V3
@property (copy,nonatomic)   NSString *imageUrl ;
//ADD IN V4
@property (nonatomic) long long createTime ;
@property (nonatomic) long long updateTime ;
@property (nonatomic) BOOL      isDel ;


- (NSString *)encodePwd:(NSString *)password ;
- (NSString *)decodePwd ;

- (instancetype)initWithName:(NSString *)name
                     account:(NSString *)account
                    password:(NSString *)password
                      detail:(NSString *)detail
                      imgUrl:(NSString *)imgUrl
                        type:(TypeOfPwdItem)type ;

+ (void)addPinyinIfNeeded ;

@end
