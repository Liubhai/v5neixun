//
//  SetingViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/15.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "SetingViewController.h"
#import "V5_Constant.h"

#import "SetingCell.h"

@interface SetingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation SetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"设置";
    _dataSource = [NSMutableArray new];
    
    [_dataSource addObjectsFromArray:@[@[@{@"title":@"修改密码",@"type":@"password",@"rightTitle":@""},
                                         @{@"title":@"第三方账号",@"type":@"third",@"rightTitle":@"微信、QQ"}],
                                       @[@{@"title":@"调整学习兴趣",@"type":@"study",@"rightTitle":@""},@{@"title":@"视频缓存清晰度",@"type":@"video",@"rightTitle":@""},@{@"title":@"允许3G/4G网络播放视频、音频",@"type":@"switch",@"rightTitle":@""},@{@"title":@"清除应用缓存",@"type":@"memory",@"rightTitle":@""},@{@"title":@"反馈",@"type":@"feedback",@"rightTitle":@""},@{@"title":@"关于",@"type":@"about",@"rightTitle":@""}],
                                       @[@{@"title":@"退出账号",@"type":@"logout",@"rightTitle":@""}]]];
    [self makeTableView];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
    line.backgroundColor = EdlineV5_Color.fengeLineColor;
    return line;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"SetingCell";
    SetingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[SetingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setSetingCellInfo:_dataSource[indexPath.section][indexPath.row]];
    return cell;
}

@end
