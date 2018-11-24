//
//  MHVideoDownloadCell.h
//  MonkeyHurry
//
//  Created by tough on 2018/11/24.
//  Copyright © 2018年 tough. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHVideoUrlParse.h"

@interface MHVideoDownloadCell : UITableViewCell

@property (nonatomic, strong) UILabel *progressLable;
@property (nonatomic, strong) UIButton *saveButton;

- (void)configData:(MHVideoParseModel *)model;

@end
