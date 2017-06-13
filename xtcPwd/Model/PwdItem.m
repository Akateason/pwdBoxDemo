//
//  PwdItem.m
//  xtcPwd
//
//  Created by teason23 on 2017/6/13.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "PwdItem.h"
#import "Base64.h"

@implementation PwdItem

- (instancetype)initWithName:(NSString *)name
                     account:(NSString *)account
                    password:(NSString *)password
                      detail:(NSString *)detail
                        type:(TypeOfPwdItem)type
{
    self = [super init];
    if (self)
    {
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

@end
