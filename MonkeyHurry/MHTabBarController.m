//
//  MHTabBarController.m
//  MonkeyHurry
//
//  Created by tough on 2018/11/21.
//  Copyright © 2018年 tough. All rights reserved.
//

#import "MHTabBarController.h"
#import "MHHomeViewController.h"

@interface MHTabBarController ()

@end

@implementation MHTabBarController

+ (instancetype)sharedInstance {
    static MHTabBarController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void){
        instance = [[MHTabBarController alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupViewControllers];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupViewControllers {
    MHHomeViewController * homeVC = [[MHHomeViewController alloc]init];
    homeVC.view.backgroundColor = [UIColor whiteColor];
    UITabBarItem *homeItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"home_youtube_normal"] selectedImage:[UIImage imageNamed:@"home_youtube_selected"]];
    homeVC.tabBarItem = homeItem;
    
    UIViewController *placeholderVC = [[UIViewController alloc]init];
    placeholderVC.tabBarItem.title = @"下载";
    placeholderVC.view.backgroundColor = [UIColor yellowColor];
    UITabBarItem *downloadItem = [[UITabBarItem alloc] initWithTitle:@"下载" image:[UIImage imageNamed:@"download_youtube_normal"] selectedImage:[UIImage imageNamed:@"download_youtube_selected"]];
    placeholderVC.tabBarItem = downloadItem;
    
    self.viewControllers = @[homeVC, placeholderVC];
}

@end
