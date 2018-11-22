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
    [self addSubview:_thumbnailImageView];
    [_thumbnailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_offset(0);
        make.width.height.mas_equalTo(80);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.thumbnailImageView.mas_right).mas_offset(6);
        make.top.mas_offset(6);
        make.right.mas_offset(0);
    }];
}

- (void)showWithVideoModel:(MHVideoParseModel *)model {
    [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    self.titleLabel.text = model.title;
}

@end
