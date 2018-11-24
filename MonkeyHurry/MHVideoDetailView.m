//
//  MHVideoDetailView.m
//  MonkeyHurry
//
//  Created by tough on 2018/11/22.
//  Copyright © 2018年 tough. All rights reserved.
//

#import "MHVideoDetailView.h"

@interface MHVideoDetailView ()

@property (nonatomic, strong) UIImageView *thumbnailImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MHVideoDetailView

- (instancetype)init {
    if (self = [super initWithFrame:CGRectZero]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _thumbnailImageView = [UIImageView new];
    _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
    _thumbnailImageView.clipsToBounds = YES;
    [self addSubview:_thumbnailImageView];
    [_thumbnailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_offset(0);
        make.width.height.mas_equalTo(80);
    }];
    
    _downloadButton = [UIButton new];
    [_downloadButton setTitle:@"下载" forState:UIControlStateNormal];
    _downloadButton.backgroundColor = [UIColor redColor];
    [self addSubview:_downloadButton];
    [_downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(65, 40));
        make.centerY.mas_offset(0);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.numberOfLines = 0;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.thumbnailImageView.mas_right).mas_offset(6);
        make.top.mas_offset(6);
        make.bottom.mas_offset(-6);
        make.right.mas_equalTo(self.downloadButton.mas_left).mas_offset(-6);
    }];
}

- (void)showWithVideoModel:(MHVideoParseModel *)model {
    [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    self.titleLabel.text = model.title;
}

@end
