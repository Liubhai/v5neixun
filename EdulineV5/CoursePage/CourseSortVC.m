//
//  CourseSortVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/7.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseSortVC.h"
#import "CourseCommonCell.h"
#import "V5_Constant.h"

@interface CourseSortVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation CourseSortVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    _titleImage.hidden = YES;
    _dataSource = [NSMutableArray new];
    if ([_pageClass isEqualToString:@"joinCourse"]) {
        [_dataSource addObjectsFromArray:@[@{@"title":@"全部",@"id":@"all"},@{@"title":@"未开始",@"id":@"not_started"},@{@"title":@"学习中",@"id":@"learning"},@{@"title":@"已完成",@"id":@"finished"}]];
    } else if ([_pageClass isEqualToString:@"incomeTime"]) {
        [_dataSource addObjectsFromArray:@[@{@"title":@"全部",@"id":@"all"},@{@"title":@"本月",@"id":@"month"}]];
    } else if ([_pageClass isEqualToString:@"incomeType"]) {
        if (_isTeacher) {
            [_dataSource addObjectsFromArray:@[@{@"title":@"全部",@"id":@"all"},@{@"title":@"分成",@"id":@"teacher"},@{@"title":@"推广",@"id":@"user"}]];
        } else {
            [_dataSource addObjectsFromArray:@[@{@"title":@"全部",@"id":@"all"},@{@"title":@"推广",@"id":@"user"}]];
        }
    } else if ([_pageClass isEqualToString:@"myExamType"]) {
        // 我的考试里面几个分类
        [_dataSource addObjectsFromArray:@[@{@"title":@"考试记录",@"id":@"examRecord"},@{@"title":@"错题本",@"id":@"errorExam"},@{@"title":@"题目收藏",@"id":@"examCollect"}]];
    } else if ([_pageClass isEqualToString:@"incomeMainType"]) {
        [_dataSource addObjectsFromArray:@[@{@"title":@"推广收入",@"id":@"all"},@{@"title":@"推广课程",@"id":@"course"},@{@"title":@"推广用户",@"id":@"user"}]];
    } else {
        [_dataSource addObjectsFromArray:@[@{@"title":@"综合排序",@"id":@"default"},@{@"title":@"推荐",@"id":@"splendid"},@{@"title":@"畅销",@"id":@"popular"},@{@"title":@"最新",@"id":@"latest"}]];
    }
    [self maketableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenCourseTypeVC:) name:@"hiddenCourseAll" object:nil];
}

- (void)maketableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _dataSource.count * 60)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"SearchHistoryListCell";
    CourseCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[CourseCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse showOneLine:YES];
    }
    [cell setCourseCommonCellInfo:_dataSource[indexPath.row] searchKeyWord:_typeId];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _typeId = [NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"title"]];
    [_tableView reloadData];
    if (_delegate && [_delegate respondsToSelector:@selector(sortTypeChoose:)]) {
        [_delegate sortTypeChoose:_dataSource[indexPath.row]];
    }
}

- (void)hiddenCourseTypeVC:(NSNotification *)notice {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
