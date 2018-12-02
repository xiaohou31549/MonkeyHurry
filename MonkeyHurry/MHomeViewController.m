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

@interface MHHomeViewController () <WKNavigationDelegate>

@property (nonatomic, strong) MHVideoUrlParse *videoUrlParse;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIButton *parseButton;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) MHVideoParseModel *videoDetail;
@property (nonatomic, strong) MHVideoDetailView *videoParseView;

@end

@implementation MHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateParseUrl) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)updateParseUrl {
    NSString *pasteboard= [self getPasteboardText];
    if (pasteboard && pasteboard.length > 0) {
        self.inputTextField.text = pasteboard;
    }
}

- (NSString *)getPasteboardText {
    NSString *pasteboard = [UIPasteboard generalPasteboard].string;
    BOOL isValidUrl = ([pasteboard rangeOfString:@"http"].location != NSNotFound) || ([pasteboard rangeOfString:@"https"].location != NSNotFound);
    return isValidUrl ? pasteboard : nil;
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
    _parseButton.enabled = YES;
    
    _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_parseButton addSubview:_loadingIndicator];
    [_loadingIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_offset(0);
    }];
    _loadingIndicator.hidden = YES;
    
    _inputTextField = [UITextField new];
    _inputTextField.backgroundColor = [UIColor grayColor];
    _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [inputView addSubview:_inputTextField];
    [_inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_offset(0);
        make.right.mas_equalTo(self.parseButton.mas_left).mas_offset(-10);
    }];
    _inputTextField.text = [self getPasteboardText];
    
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
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:MHStartDownloadVideoNoti object:self.videoDetail];
}

- (void)parseVideoUrl {
    [self.view endEditing:YES];
    NSString *videoUrl = _inputTextField.text;
    if (videoUrl && videoUrl.length > 0) {
        self.parseButton.enabled = NO;
        self.parseButton.backgroundColor = [UIColor darkGrayColor];
        [self.parseButton setTitle:@"" forState:UIControlStateNormal];
        self.loadingIndicator.hidden = NO;
        [self.loadingIndicator startAnimating];
        self.videoUrlParse = [[MHVideoUrlParse alloc] init];
        __weak typeof(self) weakSelf = self;
        [self.videoUrlParse parseWithUrl:videoUrl completion:^(MHVideoParseModel *result, NSError *error) {
            weakSelf.parseButton.enabled = YES;
            weakSelf.parseButton.backgroundColor = [UIColor redColor];
            [weakSelf.parseButton setTitle:@"解析" forState:UIControlStateNormal];
            weakSelf.loadingIndicator.hidden = YES;
            [weakSelf.loadingIndicator stopAnimating];
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

@end
