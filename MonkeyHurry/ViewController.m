//
//  ViewController.m
//  MonkeyHurry
//
//  Created by tough on 2018/11/12.
//  Copyright © 2018年 tough. All rights reserved.
//

#import "ViewController.h"
#import "MHVideoDownload.h"

@interface ViewController () <MHVideoDownloadDelegate>

@property (nonatomic, strong) MHVideoDownload *videoDownload;
@property (nonatomic, strong) UILabel *progressLabel;

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

@end
