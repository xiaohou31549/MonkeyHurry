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
#import "MHVideoUrlParse.h"

@interface ViewController () <MHVideoDownloadDelegate, WKNavigationDelegate>

@property (nonatomic, strong) MHVideoDownload *videoDownload;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) MHVideoUrlParse *videoUrlParse;
@property (nonatomic, strong) MHVideoParseModel *parseModel;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIButton *parseButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _inputTextField = [UITextField new];
    _inputTextField.frame = CGRectMake(30, 100, 250, 50);
    _inputTextField.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_inputTextField];
    
    _parseButton = [UIButton new];
    [_parseButton setTitle:@"解析" forState:UIControlStateNormal];
    _parseButton.backgroundColor = [UIColor redColor];
    _parseButton.frame = CGRectMake(300, 100, 50, 30);
    [self.view addSubview:_parseButton];
    [_parseButton addTarget:self action:@selector(parseVideoUrl) forControlEvents:UIControlEventTouchUpInside];
    
    _progressLabel = [UILabel new];
    _progressLabel.frame = CGRectMake(30, 200, 240, 250);
    _progressLabel.numberOfLines = 0;
    [self.view addSubview:_progressLabel];
    
    UIButton *downloadButton = [UIButton new];
    downloadButton.backgroundColor = [UIColor grayColor];
    downloadButton.frame = CGRectMake(280, 200, 80, 50);
    [downloadButton setTitle:@"开始下载" forState:UIControlStateNormal];
    [self.view addSubview:downloadButton];
    [downloadButton addTarget:self action:@selector(startDownload) forControlEvents:UIControlEventTouchUpInside];
}

- (void)startDownload {
    self.videoDownload = [[MHVideoDownload alloc] initWithVideoUrl:self.parseModel.url];
    self.videoDownload.delegate = self;
    [self.videoDownload startDownload];
}

- (void)parseVideoUrl {
    NSString *videoUrl = _inputTextField.text;
    if (videoUrl && videoUrl.length > 0) {
        self.videoUrlParse = [[MHVideoUrlParse alloc] init];
        __weak typeof(self) weakSelf = self;
        [self.videoUrlParse parseWithUrl:videoUrl completion:^(MHVideoParseModel *result, NSError *error) {
            if (error) {
                NSLog(@"解析视频url错误");
            } else {
                if (result) {
                    NSLog(@"video标题:%@--video下载地址:%@", result.title, result.url);
                    weakSelf.parseModel = result;
                    weakSelf.progressLabel.text = [NSString stringWithFormat:@"%@", result.title];
                }
            }
        }];
    }
}

#pragma mark - MHVideoDownloadDelegate;
- (void)videoDownloadProgress:(float)progress {
    NSString *videoTitle = self.parseModel.title ? : @"";
    NSString *value = [NSString stringWithFormat:@"%@:%.2f%%", videoTitle, progress];
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

@end
