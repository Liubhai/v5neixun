//
//  MySubordinateVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/1.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MySubordinateVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "MyMenberCell.h"

@interface MySubordinateVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation MySubordinateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (_isFirst) {
        _titleLabel.text = @"我的成员";
    } else {
        _titleLabel.text = @"成员详情";
    }
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    _lineTL.hidden = NO;
    _dataSource = [NSMutableArray new];
    [self makeTableView];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isFirst) {
        return 1;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isFirst) {
        return _dataSource.count;
    } else {
        if (section == 0) {
            return 1;
        } else {
            return _dataSource.count;
        }
    }
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isFirst) {
        static NSString *reuse = @"MyMenberCell";
        MyMenberCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[MyMenberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setMenberInfo:_dataSource[indexPath.row]];
        return cell;
    } else {
        if (indexPath.section == 0) {
            static NSString *reuse = @"MyMenberCellfirst";
            MyMenberCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
            if (!cell) {
                cell = [[MyMenberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
            }
            [cell setMenberInfo:_firstDict];
            return cell;
        } else {
            static NSString *reuse = @"MyMenberCell";
            MyMenberCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
            if (!cell) {
                cell = [[MyMenberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
            }
            [cell setMenberInfo:_dataSource[indexPath.row]];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_isFirst) {
        return nil;
    } else {
        if (section == 0) {
            return nil;
        } else {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 50)];
            view.backgroundColor = EdlineV5_Color.backColor;
            UILabel *theme = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 50)];
            theme.text = @"他的成员";
            theme.font = SYSTEMFONT(14);
            theme.textColor = EdlineV5_Color.textSecendColor;
            [view addSubview:theme];
            return view;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_isFirst) {
        return 0.001;
    } else {
        if (section == 0) {
            return 0.001;
        } else {
            return 50.0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isFirst) {
        MySubordinateVC *vc = [[MySubordinateVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if (indexPath.section != 0) {
            MySubordinateVC *vc = [[MySubordinateVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
