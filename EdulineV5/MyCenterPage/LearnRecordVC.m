//
//  LearnRecordVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/12.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "LearnRecordVC.h"
#import "LearnRecordCell.h"
#import "V5_Constant.h"

@interface LearnRecordVC ()<UITableViewDataSource,UITableViewDelegate> {
    
}

@property (strong ,nonatomic)UITableView *tableView;

@end

@implementation LearnRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"我的学习记录";
    [self makeTableView];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"LearnRecordCell";
    LearnRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[LearnRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
    } else {
        cell.topLine.hidden = NO;
    }
    if (indexPath.row == 2) {
        cell.bottomLine.hidden = YES;
    } else {
        cell.bottomLine.hidden = NO;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 40)];
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 50)];
    sectionLabel.text = @"5月2日";
    sectionLabel.font = SYSTEMFONT(14);
    sectionLabel.textColor = EdlineV5_Color.textFirstColor;
    [view1 addSubview:sectionLabel];
    return view1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

@end
