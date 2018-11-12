//
//  ReqUtil.m
//  xtcPwd
//
//  Created by xtc on 2018/2/1.
//  Copyright © 2018年 teason. All rights reserved.
//

#import "ReqUtil.h"
#import "BYImageValue.h"
#import <YYModel.h>

#define BYAPI_Token     @"085f13cddd7d42aeabec8012f1f0cab6"

@implementation ReqUtil

+ (void)searchImageWithName:(NSString *)name
                      count:(int)count
                     offset:(int)offset
                 completion:(void (^)(NSArray *list))returnImages
                       
{
    NSDictionary *header = @{@"Ocp-Apim-Subscription-Key":BYAPI_Token} ;
    
    XT_GET_PARAM
    if (name) [param setObject:name forKey:@"q"] ;
    [param setObject:@(count) forKey:@"count"] ;
    [param setObject:@(offset) forKey:@"offset"] ;
    [param setObject:@"zh-CN" forKey:@"mkt"] ;
    
    [XTCacheRequest cachedReq:XTRequestMode_GET_MODE url:@"https://api.cognitive.microsoft.com/bing/v7.0/images/search" hud:NO header:header param:param body:nil policy:XTReqPolicy_NeverCache_WaitReturn overTimeIfNeed:0 judgeResult:^XTReqSaveJudgment(BOOL isNewest, id json) {

        id value = json[@"value"] ;
        NSArray *list = [NSArray yy_modelArrayWithClass:[BYImageValue class] json:value] ;
        returnImages(list) ;
        
        return !value ? XTReqSaveJudgment_NotSave : XTReqSaveJudgment_willSave ;

    }] ;
}

@end
