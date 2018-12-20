//
//  PhotosVC.m
//  xtcPwd
//
//  Created by xtc on 2018/2/6.
//  Copyright © 2018年 teason. All rights reserved.
//

#import "PhotosVC.h"
#import "PwdItem.h"
#import "BYImageValue.h"
#import <ReactiveObjC.h>
#import "XTColor+MyColors.h"

@interface PhotosVC () <UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView ;
@property(nonatomic,strong)NSMutableArray *imgUrlArray;


@end

@implementation PhotosVC

- (NSMutableArray *)imgUrlArray {
    if (!_imgUrlArray) {
        _imgUrlArray = [NSMutableArray array];
    }
    return _imgUrlArray;
}


- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    self.webView = ({
        UIWebView *webView = [[UIWebView alloc] init] ;
        [self.view addSubview:webView] ;
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view) ;
        }];
        webView ;
    });
    self.webView.delegate = self ;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.mainUrlString]];
    [self.webView loadRequest:request] ;
    
    [SVProgressHUD show];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated] ;
    
    [SVProgressHUD dismiss] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


/**
 *  开始加载webView
 */
- (void)webViewDidStartLoad:(UIWebView *)webView {
    //@"正在加载"
}

/**
 *  webView加载完成
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
    
    // 网页注入JS获取图片资源、添加点击事件
    //这里是js，主要目的实现对url的获取
    static  NSString * const jsGetImages = @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    return imgScr;\
    };";
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    NSString *urlResurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    [self.imgUrlArray setArray:[urlResurlt componentsSeparatedByString:@"+"]];
    if (self.imgUrlArray.count >= 2) {
        [self.imgUrlArray removeLastObject];
    }
    //图片添加点击js
    [webView stringByEvaluatingJavaScriptFromString:@"function registerImageClickAction(){\
     var imgs=document.getElementsByTagName('img');\
     var length=imgs.length;\
     for(var i=0;i<length;i++){\
     img=imgs[i];\
     img.onclick=function(){\
     window.location.href='image-preview:'+this.src}\
     }\
     }"];
    [webView stringByEvaluatingJavaScriptFromString:@"registerImageClickAction();"];
}

// 在这个方法中捕获到图片的点击事件和被点击图片的 url
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // 预览图片
    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
        NSString *path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        self.item.imageUrl = path ;
        if ([self.item xt_update]) {
            [self.subject sendNext:path] ;
            [self.subject sendCompleted] ;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NoteEditDone" object:self.item] ;
            [self.navigationController popViewControllerAnimated:YES] ;
        }
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"加载失败"];
}


@end
