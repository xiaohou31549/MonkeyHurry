//
//  MHDownloadViewController.m
//  MonkeyHurry
//
//  Created by tough on 2018/11/24.
//  Copyright © 2018年 tough. All rights reserved.
//

#import "MHDownloadViewController.h"
#import "MHVideoDownloadCell.h"
#import "MHConstants.h"
#import "MHVideoDownload.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface MHDownloadViewController ()

@property (nonatomic, strong) NSMutableArray<MHVideoParseModel *> *downloadingViedos;
@property (nonatomic, strong) NSMutableArray<MHVideoParseModel *> *downloadedViedeos;

@property (nonatomic, strong) NSMutableArray<MHVideoDownload *> *downloadTasks;

@end

@implementation MHDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observerVideoDownloadNoti:) name:MHStartDownloadVideoNoti object:nil];
    _downloadingViedos = [NSMutableArray array];
    _downloadedViedeos = [NSMutableArray array];
    _downloadTasks = [NSMutableArray array];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarItem.badgeValue = nil;
}


- (void)setupTableView {
    [self.tableView registerClass:[MHVideoDownloadCell class] forCellReuseIdentifier:NSStringFromClass([MHVideoDownloadCell class])];
    self.tableView.rowHeight = 60;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.tableFooterView = [UIView new];
}

- (void)observerVideoDownloadNoti:(NSNotification *)noti {
    id notiObject = noti.object;
    if (notiObject && [notiObject isKindOfClass:[MHVideoParseModel class]]) {
        NSInteger badgeValue = self.tabBarItem.badgeValue ? self.tabBarItem.badgeValue.integerValue : 0;
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@", @(badgeValue + 1)];
        MHVideoParseModel *model = (MHVideoParseModel *)notiObject;
        NSString *videoUrl = model.url;
        if (videoUrl && videoUrl.length > 0) {
            MHVideoDownload *task = [[MHVideoDownload alloc] initWithVideoUrl:videoUrl];
            task.isSaveToPhotoAlbum = YES;
            [self.downloadTasks addObject:task];
            [self.downloadingViedos addObject:model];
            [self.tableView reloadData];
            NSInteger cellRow = self.downloadingViedos.count - 1;
            __weak typeof(self) weakSelf = self;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellRow inSection:0] ;
            MHVideoDownloadCell *downloadCell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
            [task startDownload:^(BOOL isDownloadSuccess, NSError *error) {
                NSLog(@"下载结果：%@--error:%@", @(isDownloadSuccess), error);
                if (isDownloadSuccess) {
                    downloadCell.progressLable.text = @"已下载";
                }
            } progressBlock:^(float progress) {
                downloadCell.progressLable.text = [NSString stringWithFormat:@"%.2f%%", progress];
            } saveBlock:^(BOOL isSaveSuccess, NSError *error) {
                NSLog(@"保存相册结果：%@--error:%@", @(isSaveSuccess), error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isSaveSuccess) {
                        downloadCell.progressLable.text = @"已保存";
                    }
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = error ? error.localizedDescription : @"保存相册成功";
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES];
                    });
                });
            }];
        } else {
            NSLog(@"video url 为空");
        }

        NSLog(@"title:%@---download url:%@", model.title, model.url);
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.downloadingViedos.count;
    } else {
        return self.downloadedViedeos.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MHVideoDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MHVideoDownloadCell class]) forIndexPath:indexPath];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    MHVideoParseModel *model  = section == 0 ? self.downloadingViedos[row] : self.downloadedViedeos[row];
    cell.saveButton.hidden = section == 0;
    cell.tag = row;
//    [cell.saveButton addTarget:self action:@selector(saveToPhotoAlbum:) forControlEvents:UIControlEventTouchUpInside];
    [cell configData:model];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    return cell;
}

@end
