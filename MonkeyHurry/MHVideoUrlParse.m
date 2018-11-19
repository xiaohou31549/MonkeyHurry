//
//  MHVideoUrlParse.m
//  MonkeyHurry
//
//  Created by tough on 2018/11/19.
//  Copyright © 2018年 tough. All rights reserved.
//

#import "MHVideoUrlParse.h"
#import <WebKit/WebKit.h>
#import <TFHpple/TFHpple.h>

@implementation MHVideoParseModel

@end

@interface MHVideoUrlParse () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) void(^parseBlock)(MHVideoParseModel *result, NSError *error);

@end

@implementation MHVideoUrlParse

- (instancetype)init {
    if (self = [super init]) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _webView.navigationDelegate = self;
    }
    return self;
}

- (void)parseWithUrl:(NSString *)url completion:(void(^)(MHVideoParseModel *result, NSError *error))completion {
    NSURL *videoUrl = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:videoUrl];
    self.parseBlock = completion;
    [self.webView loadRequest:request];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.webView evaluateJavaScript:@"document.documentElement.outerHTML.toString()" completionHandler:^(id _Nullable html, NSError * _Nullable error) {
        if (error) {
            if (self.parseBlock) {
                self.parseBlock(nil, error);
            }
            NSLog(@"解析html出错：%@", error);
        } else {
            MHVideoParseModel *model = nil;
            if (html) {
                NSString *htmlString = (NSString *)html;
                TFHpple *parser = [TFHpple hppleWithHTMLData:[htmlString dataUsingEncoding:NSUTF8StringEncoding]];
                NSArray <TFHppleElement *> *videos = [parser searchWithXPathQuery:@"//video"];
                TFHppleElement *firstElement = videos.firstObject;
                if (firstElement) {
                    NSString *videoUrl = firstElement.attributes[@"src"];
                    NSString *title = firstElement.attributes[@"title"];
                    model = [MHVideoParseModel new];
                    model.url = videoUrl;
                    model.title = title;
                }
            } else {
                NSLog(@"html结果为空");
            }
            if (self.parseBlock) {
                self.parseBlock(model, nil);
            }
        }
    }];
}

@end
