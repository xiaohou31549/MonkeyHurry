//
//  MHVideoDownloadService.m
//  MonkeyHurry
//
//  Created by tough on 2018/11/24.
//  Copyright © 2018年 tough. All rights reserved.
//

#import "MHVideoDownloadService.h"
#import "MHVideoUrlParse.h"

@implementation MHVideoDownloadService

+ (instancetype)sharedInstance {
    static MHVideoDownloadService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void){
        instance = [[MHVideoDownloadService alloc] init];
    });
    return instance;
}

- (void)downloadVideoWithModel:(MHVideoParseModel *)model {
//    NSString *videoUrl = model.url;
//    if (videoUrl) {
//        self.videoDownload = [[MHVideoDownload alloc] initWithVideoUrl:videoUrl];
//        self.videoDownload.delegate = self;
//        [self.videoDownload startDownload];
//    } else {
//        NSLog(@"video url 为空");
//    }
}

@end
