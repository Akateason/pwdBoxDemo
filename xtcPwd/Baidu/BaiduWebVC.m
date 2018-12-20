//
//  BaiduWebVC.m
//  xtcPwd
//
//  Created by teason23 on 2018/12/19.
//  Copyright © 2018 teason. All rights reserved.
//

#import "BaiduWebVC.h"
#import <XTBase/XTBase.h>

typedef void(^BlockPhotoChoosen)(NSString *imageUrlString);

@interface BaiduWebVC () <UIWebViewDelegate>
@property (strong, nonatomic) NSMutableArray *mUrlArray ;
@property (copy, nonatomic) BlockPhotoChoosen blkChoosen ;
@property (strong, nonatomic) UIWebView *webView ;
@property (copy, nonatomic) NSString *mainUrlString ;
@end

@implementation BaiduWebVC

+ (instancetype)newWithSchName:(NSString *)search
                 photoSelected:(void(^)(NSString *imgUrlStr))blkPhotoSelected {
    
    BaiduWebVC *webVC = [[BaiduWebVC alloc] init] ;
    webVC.mainUrlString = [NSString stringWithFormat:@"https://image.baidu.com/search/index?tn=baiduimage&word=%@",search] ;
    webVC.blkChoosen = blkPhotoSelected ;
    return webVC ;
}


- (void)viewDidLoad {
    [super viewDidLoad];

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
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 这里是 js，主要目的实现对 url 的获取
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
                                             var imgScr = '';\
                                             for(var i=0;i<objs.length;i++){\
                                                 imgScr = imgScr + objs[i].src + '+';\
                                             };\
                                             return imgScr;\
                                             };";
    
     [webView stringByEvaluatingJavaScriptFromString:jsGetImages];// 注入 js 方法
     NSString *urlResurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
     self.mUrlArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
     if (self.mUrlArray.count >= 2) {
         [self.mUrlArray removeLastObject];
     }
     //urlResurlt 就是获取到得所有图片的 url 的拼接；mUrlArray 就是所有 Url 的数组
     // 添加图片可点击 js
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
                                              
                                              
//定义要注入的css代码，这段代码是往页面head便签中添加style样式
NSString *const INJECT_CSS = @"var head = document.getElementsByTagName('head');\
var tagStyle=document.createElement(\"style\"); tagStyle.setAttribute(\"type\", \"text/css\");\
                                    tagStyle.appendChild(document.createTextNode(\"iframe{-webkit-transform:translateZ(0px)}\"));\
                                                                                 head[0].appendChild(tagStyle);";

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:INJECT_CSS];
}
                                                                                 
// 在这个方法中捕获到图片的点击事件和被点击图片的 url
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  // 预览图片
  if ([request.URL.scheme isEqualToString:@"image-preview"]) {
      NSString *path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
      self.blkChoosen(path) ;
      [self.navigationController popViewControllerAnimated:YES] ;
      return NO;
  }
  return YES;
}

@end
