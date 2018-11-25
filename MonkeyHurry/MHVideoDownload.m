//
//  MHVideoDownload.m
//  MonkeyHurry
//
//  Created by tough on 2018/11/13.
//  Copyright © 2018年 tough. All rights reserved.
//

#import "MHVideoDownload.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface MHVideoDownload () <NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *downloadSession;
@property (nonatomic, strong) NSURLSessionDownloadTask *dataTask;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, copy) void(^downloadBlock)(BOOL isSuccess, NSError *error);
@property (nonatomic, copy) void(^progressBlock)(float progress);

@end

@implementation MHVideoDownload

- (instancetype)initWithVideoUrl:(NSString *)url{
    if (self = [super init]) {
        _url = url;
        
    }
    return self;
}

- (void)startDownload:(void(^)(BOOL isSuccess, NSError *error))completion progressBlock:(void(^)(float progress))progressBlock  {
    _downloadBlock = completion;
    _progressBlock = progressBlock;
    NSURL *downloadUrl = [NSURL URLWithString:_url];
    if (downloadUrl) {
        _downloadSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        _dataTask = [_downloadSession downloadTaskWithURL:downloadUrl];
        [_dataTask resume];
    } else {
        NSLog(@"下载的url异常，请检查");
    }
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    float percentValue = ((float)totalBytesWritten/totalBytesExpectedToWrite) * 100;
    if (self.progressBlock) {
        self.progressBlock(percentValue);
    }
}

-(void)URLSession:(nonnull NSURLSession *)session
     downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(nonnull NSURL *)location {
    if (self.downloadBlock) {
        self.downloadBlock(YES, nil);
    }
    if (self.isSaveToPhotoAlbum) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MMdd-HH-mm-ss"];
        
        NSDate *currentDate = [NSDate date];
        NSString *dateString = [formatter stringFromDate:currentDate];
        NSString *fileName = [NSString stringWithFormat:@"%@.mp4", dateString];
        NSString *saveDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *path = [saveDir stringByAppendingPathComponent:fileName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:path]){
            [fileManager removeItemAtPath:path error:nil];
        }
        NSError *saveError = nil;
        NSURL *fileUrl = [NSURL fileURLWithPath:path];
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:fileUrl error:&saveError];
        if (saveError) {
            NSLog(@"视频保存沙盒失败");
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                [library writeVideoAtPathToSavedPhotosAlbum:fileUrl completionBlock:^(NSURL *assetURL, NSError *error)
                 {
                     if (error) {
                         NSLog(@"保存相册失败:%@", error);
                     } else {
                         NSLog(@"保存相册成功");
                     }
                 }];
            });
        }
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (self.downloadBlock && error) {
        self.downloadBlock(NO, error);
    }
}

@end
