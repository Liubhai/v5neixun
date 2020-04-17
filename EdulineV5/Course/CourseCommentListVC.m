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
#import "Net_Path.h"

@interface CourseCommentListVC ()<UITableViewDelegate,UITableViewDataSource,CourseCommentCellDelegate,CourseCommentTopViewDelegate,UIScrollViewDelegate> {
    NSInteger page;
}

@property (strong, nonatomic) CourseCommentTopView *headerView;

@end

@implementation CourseCommentListVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    page = 1;
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
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    [self getCourseCommentList];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"CourseCommentCell";
    CourseCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[CourseCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse cellType:_cellType];
    }
    cell.delegate = self;
    [cell setCommentInfo:_dataSource[indexPath.row]];
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
    vc.topCellInfo = cell.userCommentInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToCommentVC {
    CourseCommentViewController *vc = [[CourseCommentViewController alloc] init];
    vc.isComment = !_cellType;
    vc.courseId = _courseId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)zanComment:(CourseCommentCell *)cell {
    // 判断是点赞还是取消点赞  然后再判断是展示我的还是展示所有的
    if (!SWNOTEmptyDictionary(cell.userCommentInfo)) {
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary new];
    if ([[cell.userCommentInfo objectForKey:@"like"] boolValue]) {
        // 取消点赞
        [param setObject:@"0" forKey:@"status"];
    } else {
        // 点赞
        [param setObject:@"1" forKey:@"status"];
    }
    NSString *commentId = [NSString stringWithFormat:@"%@",[cell.userCommentInfo objectForKey:@"id"]];
    BOOL likeStatus = [[cell.userCommentInfo objectForKey:@"like"] boolValue];
    [Net_API requestPUTWithURLStr:[Net_Path zanComment:commentId] paramDic:param Api_key:nil finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                // 改变UI
                NSString *zanCount = [NSString stringWithFormat:@"%@",[cell.userCommentInfo objectForKey:@"like_count"]];
                if (likeStatus) {
                    zanCount = [NSString stringWithFormat:@"%@",@(zanCount.integerValue - 1)];
                    [cell changeZanButtonInfo:zanCount zanOrNot:NO];
                } else {
                    zanCount = [NSString stringWithFormat:@"%@",@(zanCount.integerValue + 1)];
                    [cell changeZanButtonInfo:zanCount zanOrNot:YES];
                }
                // 改变数据源 先改变所有数据源 用id匹配
                // 点赞数 点赞状态(脑壳昏 想直接请求接口)
                NSMutableDictionary *allCommentInfoPass = [NSMutableDictionary dictionaryWithDictionary:_allCommentInfo];
                NSMutableDictionary *dataPass = [NSMutableDictionary dictionaryWithDictionary:[_allCommentInfo objectForKey:@"data"]];
                NSMutableDictionary *my_commentInfo = [NSMutableDictionary dictionaryWithDictionary:[dataPass objectForKey:@"my_comment"]];
                if ([[my_commentInfo allKeys] count]) {
                    if ([[NSString stringWithFormat:@"%@",[my_commentInfo objectForKey:@"id"]] isEqualToString:commentId]) {
                        [my_commentInfo setObject:zanCount forKey:@"like_count"];
                        [my_commentInfo setObject:@(!likeStatus) forKey:@"like"];
                        [dataPass setObject:my_commentInfo forKey:@"my_comment"];
                    }
                }
                
                NSMutableDictionary *listPass = [NSMutableDictionary dictionaryWithDictionary:[dataPass objectForKey:@"list"]];
                NSMutableArray *listDataArray = [NSMutableArray arrayWithArray:[listPass objectForKey:@"data"]];
                for (int i = 0; i<listDataArray.count; i++) {
                    NSMutableDictionary *pass = [NSMutableDictionary dictionaryWithDictionary:listDataArray[i]];
                    if ([[NSString stringWithFormat:@"%@",[pass objectForKey:@"id"]] isEqualToString:commentId]) {
                        [pass setObject:zanCount forKey:@"like_count"];
                        [pass setObject:@(!likeStatus) forKey:@"like"];
                        [listDataArray replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithDictionary:pass]];
                        [listPass setObject:[NSArray arrayWithArray:listDataArray] forKey:@"data"];
                        [dataPass setObject:[NSDictionary dictionaryWithDictionary:listPass] forKey:@"list"];
                        [allCommentInfoPass setObject:dataPass forKey:@"data"];
                        _allCommentInfo = [NSDictionary dictionaryWithDictionary:allCommentInfoPass];
                        break;
                    }
                }
                [_dataSource removeAllObjects];
                if (_headerView.showOwnButton.selected) {
                    if (SWNOTEmptyDictionary([[_allCommentInfo objectForKey:@"data"] objectForKey:@"my_comment"])) {
                        if ([[[_allCommentInfo objectForKey:@"data"] objectForKey:@"my_comment"] allKeys].count) {
                            [_dataSource addObject:[[_allCommentInfo objectForKey:@"data"] objectForKey:@"my_comment"]];
                        }
                    }
                } else {
                    [_dataSource addObjectsFromArray:[[[_allCommentInfo objectForKey:@"data"] objectForKey:@"list"] objectForKey:@"data"]];
                }
                [_tableView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        [self showHudInView:self.view showHint:[[cell.userCommentInfo objectForKey:@"like"] boolValue] ? @"取消点赞失败" : @"点赞失败"];
    }];
}

- (void)showOwnCommentList:(UIButton *)sender {
    if (SWNOTEmptyDictionary(_allCommentInfo)) {
        [_dataSource removeAllObjects];
        if (sender.selected) {
            if (SWNOTEmptyDictionary([[_allCommentInfo objectForKey:@"data"] objectForKey:@"my_comment"])) {
                if ([[[_allCommentInfo objectForKey:@"data"] objectForKey:@"my_comment"] allKeys].count) {
                    [_dataSource addObject:[[_allCommentInfo objectForKey:@"data"] objectForKey:@"my_comment"]];
                }
            }
        } else {
            [_dataSource addObjectsFromArray:[[[_allCommentInfo objectForKey:@"data"] objectForKey:@"list"] objectForKey:@"data"]];
        }
        [_tableView reloadData];
    }
}

- (void)getCourseCommentList {
    if (SWNOTEmptyStr(_courseId)) {
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:@(page) forKey:@"page"];
        [param setObject:@"10" forKey:@"count"];
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseCommentList:_courseId] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    _allCommentInfo = [NSDictionary dictionaryWithDictionary:responseObject];
                    [_dataSource removeAllObjects];
                    [_dataSource addObjectsFromArray:[[[responseObject objectForKey:@"data"] objectForKey:@"list"] objectForKey:@"data"]];
                    [_headerView setCourseCommentInfo:[responseObject objectForKey:@"data"] commentOrRecord:_cellType];
                    [_headerView changeCommentStatus:[[[responseObject objectForKey:@"data"] objectForKey:@"has_comment"] boolValue]];
                    [_tableView reloadData];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

@end
