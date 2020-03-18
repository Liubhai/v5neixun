//
//  CourseCommentListVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/17.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseCommentListVC.h"
#import "CourseCommentTopView.h"
#import "CourseCommentCell.h"
#import "CourseCommentDetailVC.h"

@interface CourseCommentListVC ()<UITableViewDelegate,UITableViewDataSource,CourseCommentCellDelegate>

@property (strong, nonatomic) CourseCommentTopView *headerView;

@end

@implementation CourseCommentListVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleImage.hidden = YES;
    _dataSource = [NSMutableArray new];
    
    _headerView = [[CourseCommentTopView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 42)];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _tabelHeight)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = _headerView;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"CourseCommentCell";
    CourseCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[CourseCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    cell.delegate = self;
    [cell setCommentInfo:nil];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)replayComment:(CourseCommentCell *)cell {
    CourseCommentDetailVC *vc = [[CourseCommentDetailVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
