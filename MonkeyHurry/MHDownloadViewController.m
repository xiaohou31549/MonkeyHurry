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


- (void)setupTableView {
    [self.tableView registerClass:[MHVideoDownloadCell class] forCellReuseIdentifier:NSStringFromClass([MHVideoDownloadCell class])];
    self.tableView.rowHeight = 60;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.tableFooterView = [UIView new];
}

- (void)observerVideoDownloadNoti:(NSNotification *)noti {
    id notiObject = noti.object;
    if (notiObject && [notiObject isKindOfClass:[MHVideoParseModel class]]) {
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
            [task startDownload:^(BOOL isSuccess, NSError *error) {
                NSLog(@"下载成功：%@", @(isSuccess));
            } progressBlock:^(float progress) {
                MHVideoDownloadCell *downloadCell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
                downloadCell.progressLable.text = [NSString stringWithFormat:@"%.2f%%", progress];
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
