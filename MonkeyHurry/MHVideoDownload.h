//
//  MHVideoDownload.h
//  MonkeyHurry
//
//  Created by tough on 2018/11/13.
//  Copyright © 2018年 tough. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MHVideoDownloadDelegate <NSObject>

//进度数值范围：0~100
- (void)videoDownloadProgress:(float)progress;
- (void)videoDownloadCompleteWithError:(NSError *)error;
- (BOOL)videoDownloadSaveToPhotoAssets;

@end

@interface MHVideoDownload : NSObject

@property (nonatomic, weak) id<MHVideoDownloadDelegate> delegate;

- (instancetype)initWithVideoUrl:(NSString *)url;

- (void)startDownload;

@end
