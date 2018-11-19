//
//  MHVideoUrlParse.h
//  MonkeyHurry
//
//  Created by tough on 2018/11/19.
//  Copyright © 2018年 tough. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHVideoParseModel: NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;

@end

@interface MHVideoUrlParse : NSObject

- (void)parseWithUrl:(NSString *)url completion:(void(^)(MHVideoParseModel *result, NSError *error))completion;

@end
