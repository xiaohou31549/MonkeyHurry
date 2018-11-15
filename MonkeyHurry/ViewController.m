//
//  ViewController.m
//  MonkeyHurry
//
//  Created by tough on 2018/11/12.
//  Copyright © 2018年 tough. All rights reserved.
//

#import "ViewController.h"
#import "MHVideoDownload.h"
#import <WebKit/WebKit.h>
#import <TFHpple/TFHpple.h>

@interface ViewController () <MHVideoDownloadDelegate, WKNavigationDelegate>

@property (nonatomic, strong) MHVideoDownload *videoDownload;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *downloadButton = [UIButton new];
    downloadButton.backgroundColor = [UIColor grayColor];
    downloadButton.frame = CGRectMake(100, 200, 100, 60);
    [downloadButton setTitle:@"开始下载" forState:UIControlStateNormal];
    [self.view addSubview:downloadButton];
    [downloadButton addTarget:self action:@selector(startDownload) forControlEvents:UIControlEventTouchUpInside];
    
    _progressLabel = [UILabel new];
    _progressLabel.frame = CGRectMake(100, 300, 100, 60);
    [self.view addSubview:_progressLabel];
    
    [self testGetVideoUrl];
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (void)testGetVideoUrl {
    NSString *testUrl = @"https://youtu.be/NSEWCNW9wPU";
    NSURL *url = [NSURL URLWithString:testUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)startDownload {
    NSString *videoUrl = @"http://vt1.doubanio.com/201811031829/f17568f72321309cbdf275b0b0922a4a/view/movie/M/302350940.mp4";
    _videoDownload = [[MHVideoDownload alloc] initWithVideoUrl:videoUrl];
    _videoDownload.delegate = self;
    [_videoDownload startDownload];
}

#pragma mark - MHVideoDownloadDelegate;
- (void)videoDownloadProgress:(float)progress {
    NSString *value = [NSString stringWithFormat:@"%.2f%%",progress];
    self.progressLabel.text = value;
}

- (void)videoDownloadCompleteWithError:(NSError *)error {
    if (error) {
        NSLog(@"下载出现了错误：%@", error);
    } else {
        NSLog(@"下载成功");
    }
}

- (BOOL)videoDownloadSaveToPhotoAssets {
    return YES;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.webView evaluateJavaScript:@"document.documentElement.outerHTML.toString()" completionHandler:^(id _Nullable html, NSError * _Nullable error) {
        if (error) {
            NSLog(@"解析html出错：%@", error);
        } else {
            if (html) {
                NSString *htmlString = (NSString *)html;
                TFHpple *parser = [TFHpple hppleWithHTMLData:[htmlString dataUsingEncoding:NSUTF8StringEncoding]];
                NSArray <TFHppleElement *> *videos = [parser searchWithXPathQuery:@"//video"];
                TFHppleElement *firstElement = videos.firstObject;
                if (firstElement) {
                    NSString *title = firstElement.attributes[@"title"];
                    NSString *videoUrl = firstElement.attributes[@"src"];
                    NSLog(@"title:%@---url:%@", title, videoUrl);
                }
            } else {
                NSLog(@"html结果为空");
            }
        }
    }];
}

@end
