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

@interface MHDownloadViewController () <MHVideoDownloadDelegate>

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
}

- (void)observerVideoDownloadNoti:(NSNotification *)noti {
    id notiObject = noti.object;
    if (notiObject && [notiObject isKindOfClass:[MHVideoParseModel class]]) {
        MHVideoParseModel *model = (MHVideoParseModel *)notiObject;
        NSString *videoUrl = model.url;
        if (videoUrl && videoUrl.length > 0) {
            MHVideoDownload *task = [[MHVideoDownload alloc] initWithVideoUrl:videoUrl];
            task.delegate = self;
            [task startDownload];
            [self.downloadTasks addObject:task];
            [self.downloadingViedos addObject:model];
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
    [cell.saveButton addTarget:self action:@selector(saveToPhotoAlbum:) forControlEvents:UIControlEventTouchUpInside];
    [cell configData:model];
    return cell;
}

- (void)saveToPhotoAlbum:(UIButton *)sender {
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - MHVideoDownloadDelegate

- (void)videoDownloadProgress:(float)progress {
    
}

- (void)videoDownloadCompleteWithError:(NSError *)error {
    
}

- (BOOL)videoDownloadSaveToPhotoAssets {
    return YES;
}

@end
