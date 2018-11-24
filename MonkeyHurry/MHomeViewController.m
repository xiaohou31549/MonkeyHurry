//
//  ViewController.m
//  MonkeyHurry
//
//  Created by tough on 2018/11/12.
//  Copyright © 2018年 tough. All rights reserved.
//

#import "MHHomeViewController.h"
#import "MHVideoDownload.h"
#import <WebKit/WebKit.h>
#import <TFHpple/TFHpple.h>
#import "MHVideoUrlParse.h"
#import "MHVideoDetailView.h"
#import "MHConstants.h"

@interface MHHomeViewController () <MHVideoDownloadDelegate, WKNavigationDelegate>

@property (nonatomic, strong) MHVideoDownload *videoDownload;
//@property (nonatomic, strong) UILabel *progressLabel;
//@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) MHVideoUrlParse *videoUrlParse;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIButton *parseButton;
@property (nonatomic, strong) MHVideoParseModel *videoDetail;
@property (nonatomic, strong) MHVideoDetailView *videoParseView;

@end

@implementation MHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupViews];
}

- (void)setupViews {
    UIView *inputView = [UIView new];
    [self.view addSubview:inputView];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.left.mas_offset(15);
        make.height.mas_equalTo(50);
        make.top.mas_offset(80);
    }];
    
    _parseButton = [UIButton new];
    [_parseButton setTitle:@"解析" forState:UIControlStateNormal];
    _parseButton.backgroundColor = [UIColor redColor];
    [inputView addSubview:_parseButton];
    [_parseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_offset(0);
        make.right.mas_offset(0);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(40);
    }];
    [_parseButton addTarget:self action:@selector(parseVideoUrl) forControlEvents:UIControlEventTouchUpInside];
    
    _inputTextField = [UITextField new];
    _inputTextField.backgroundColor = [UIColor grayColor];
    _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [inputView addSubview:_inputTextField];
    [_inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_offset(0);
        make.right.mas_equalTo(self.parseButton.mas_left).mas_offset(-10);
    }];
    
    _videoParseView = [MHVideoDetailView new];
    [self.view addSubview:_videoParseView];
    [_videoParseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
        make.top.mas_equalTo(inputView.mas_bottom).mas_offset(15);
    }];
    [_videoParseView.downloadButton addTarget:self action:@selector(startDownload) forControlEvents:UIControlEventTouchUpInside];
    _videoParseView.hidden = YES;
}

- (void)startDownload {
    [[NSNotificationCenter defaultCenter] postNotificationName:MHStartDownloadVideoNoti object:self.videoDetail];
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
                    weakSelf.videoDetail = result;
                    [weakSelf.videoParseView showWithVideoModel:result];
                    weakSelf.videoParseView.hidden = NO;
                }
            }
        }];
    }
}

#pragma mark - MHVideoDownloadDelegate;
- (void)videoDownloadProgress:(float)progress {
    NSString *videoTitle = self.videoDetail.title ? : @"";
    NSString *value = [NSString stringWithFormat:@"%@:%.2f%%", videoTitle, progress];
//    self.progressLabel.text = value;
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
