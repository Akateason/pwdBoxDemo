//
//  PwdItem.m
//  xtcPwd
//
//  Created by teason23 on 2017/6/13.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "PwdItem.h"
#import "NSString+Extend.h"
#import "Base64.h"
#import "PinYin4Objc.h"

@implementation PwdItem

- (instancetype)initWithName:(NSString *)name
                     account:(NSString *)account
                    password:(NSString *)password
                      detail:(NSString *)detail
                      imgUrl:(NSString *)imgUrl
                        type:(TypeOfPwdItem)type
{
    self = [super init];
    if (self)
    {
        _imageUrl = imgUrl ;
        _name = name ;
        _account = account ;
        _password = [self encodePwd:password] ;
        _detailInfo = detail ;
        _typeOfPwdItem = type ;
    }
    return self;
}

- (NSString *)encodePwd:(NSString *)pwd
{
    return [pwd base64EncodedString] ;
}

- (NSString *)decodePwd
{
    return [_password base64DecodedString] ;
}

+ (void)addPinyinIfNeeded {
    NSArray *listNoPinyin = [PwdItem xt_findWithSql:@"SELECT * FROM PwdItem WHERE pinyin IS ''"] ;
    [listNoPinyin enumerateObjectsUsingBlock:^(PwdItem *item, NSUInteger idx, BOOL * _Nonnull stop) {

        HanyuPinyinOutputFormat *outputFormat = [[HanyuPinyinOutputFormat alloc] init];
        [outputFormat setToneType:ToneTypeWithoutTone];
        [outputFormat setVCharType:VCharTypeWithV];
        [outputFormat setCaseType:CaseTypeLowercase];
        NSString *outputPinyin = [PinyinHelper toHanyuPinyinStringWithNSString:item.name
                                                   withHanyuPinyinOutputFormat:outputFormat
                                                                  withNSString:@" "] ;
        item.pinyin = outputPinyin ;
    }] ;
    
    [PwdItem xt_updateListByPkid:listNoPinyin] ;
}

@end
