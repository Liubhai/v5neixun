//
//  HomeRootViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "HomeRootViewController.h"
#import "AliyunVodPlayerView.h"
#import "AliyunUtil.h"
#import "CourseMainViewController.h"
#import "AVC_VP_VideoPlayViewController.h"

@interface HomeRootViewController ()

@property (nonatomic,strong, nullable)AliyunVodPlayerView *playerView;

@end

@implementation HomeRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"首页";
}

@end
