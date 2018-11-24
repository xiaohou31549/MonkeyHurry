//
//  MHVideoDownloadCell.m
//  MonkeyHurry
//
//  Created by tough on 2018/11/24.
//  Copyright © 2018年 tough. All rights reserved.
//

#import "MHVideoDownloadCell.h"

@interface MHVideoDownloadCell ()

@property (nonatomic, strong) UIImageView *thumbnailImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MHVideoDownloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
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
        make.left.mas_offset(15);
        make.centerY.mas_offset(0);
        make.width.height.mas_equalTo(60);
    }];
    
    _saveButton = [UIButton new];
    [_saveButton setTitle:@"保存到相册" forState:UIControlStateNormal];
    _saveButton.backgroundColor = [UIColor redColor];
    [self addSubview:_saveButton];
    [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-15);
        make.size.mas_equalTo(CGSizeMake(120, 40));
        make.centerY.mas_offset(0);
    }];
    _saveButton.hidden = YES;
    
    _progressLable = [UILabel new];
    _progressLable.font = [UIFont systemFontOfSize:15];
    _progressLable.textAlignment = NSTextAlignmentRight;
    [self addSubview:_progressLable];
    [_progressLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.saveButton.mas_left).mas_offset(-6);
        make.centerY.mas_offset(0);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.numberOfLines = 0;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.progressLable.mas_right).mas_offset(6);
        make.top.mas_offset(6);
        make.bottom.mas_offset(-6);
        make.right.mas_equalTo(self.progressLable.mas_left).mas_offset(-6);
    }];
}

- (void)configData:(MHVideoParseModel *)model {
    [_thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    _titleLabel.text = model.title;
}

@end
