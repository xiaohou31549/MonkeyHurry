//
//  MHVideoDownload.h
//  MonkeyHurry
//
//  Created by tough on 2018/11/13.
//  Copyright © 2018年 tough. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHVideoDownload : NSObject

@property (nonatomic, assign) BOOL isSaveToPhotoAlbum;

- (instancetype)initWithVideoUrl:(NSString *)url;

- (void)startDownload:(void(^)(BOOL isSuccess, NSError *error))completion progressBlock:(void(^)(float progress))progressBlock;

@end
