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
#import "CourseCommentViewController.h"

@interface CourseCommentListVC ()<UITableViewDelegate,UITableViewDataSource,CourseCommentCellDelegate,CourseCommentTopViewDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) CourseCommentTopView *headerView;

@end

@implementation CourseCommentListVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleImage.hidden = YES;
    _dataSource = [NSMutableArray new];
    
    _headerView = [[CourseCommentTopView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 42) commentOrRecord:_cellType];
    _headerView.backgroundColor = [UIColor whiteColor];
    _headerView.delegate = self;
    
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
        cell = [[CourseCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse cellType:_cellType];
    }
    cell.delegate = self;
    [cell setCommentInfo:nil];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.cellTabelCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        if (self.vc) {
            if (self.vc.canScrollAfterVideoPlay == YES) {
                self.cellTabelCanScroll = NO;
                scrollView.contentOffset = CGPointZero;
                self.vc.canScroll = YES;
            }
        } else {
            if (self.detailVC.canScrollAfterVideoPlay == YES) {
                self.cellTabelCanScroll = NO;
                scrollView.contentOffset = CGPointZero;
                self.detailVC.canScroll = YES;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)replayComment:(CourseCommentCell *)cell {
    CourseCommentDetailVC *vc = [[CourseCommentDetailVC alloc] init];
    vc.cellType = _cellType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToCommentVC {
    CourseCommentViewController *vc = [[CourseCommentViewController alloc] init];
    vc.isComment = !_cellType;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
