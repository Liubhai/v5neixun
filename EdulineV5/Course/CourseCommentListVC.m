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
#import "V5_UserModel.h"
#import "AppDelegate.h"

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
    _my_dataSource = [NSMutableArray new];
    
    _headerView = [[CourseCommentTopView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 42) commentOrRecord:_cellType];
    _headerView.backgroundColor = [UIColor whiteColor];
    _headerView.delegate = self;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _tabelHeight) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = _headerView;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreList)];
    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    if (_cellType) {
        _courseHourseId = _detailVC.currentHourseId;
        [self getNoteList];
    } else {
        [self getCourseCommentList];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCourseCommentListVCData:) name:@"CourseCommentListVCRloadData" object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_cellType) {
        return _dataSource.count;
    } else {
        if (_headerView.showOwnButton.selected) {
            return _my_dataSource.count;
        }
        return _dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_cellType) {
        static NSString *reuse = @"CourseCommentCell";
        CourseCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[CourseCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse cellType:_cellType];
        }
        cell.delegate = self;
        [cell setCommentInfo:_dataSource[indexPath.row] showAllContent:NO];
        return cell;
    } else {
        static NSString *reuse = @"CourseCommentRecordCell";
        CourseCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[CourseCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse cellType:_cellType];
        }
        cell.delegate = self;
        if (_headerView.showOwnButton.selected) {
            [cell setCommentInfo:_my_dataSource[indexPath.row] showAllContent:NO];
        } else {
            [cell setCommentInfo:_dataSource[indexPath.row] showAllContent:NO];
        }
        return cell;
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_cellType) {
        return;
    }
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:_detailVC ? _detailVC : _vc];
        return;
    }
    NSString *isBuy = [NSString stringWithFormat:@"%@",[(_detailVC ? _detailVC.dataSource : _vc.dataSource) objectForKey:@"is_buy"]];
    if (![isBuy isEqualToString:@"1"]) {
//        if (_detailVC) {
//            [_detailVC showHudInView:_detailVC.view showHint:@"购买课程后方可进入他人评论详情页"];
//        } else {
//            [_vc showHudInView:_vc.view showHint:@"购买课程后方可进入他人评论详情页"];
//        }
//        return;
    }
    
    NSDictionary *pass = [NSDictionary dictionaryWithDictionary:_dataSource[indexPath.row]];
    if (_headerView.showOwnButton.selected && !_cellType) {
        pass = [NSDictionary dictionaryWithDictionary:_my_dataSource[indexPath.row]];
    }
    BOOL isMine = NO;
    if (SWNOTEmptyDictionary(pass)) {
        if ([[NSString stringWithFormat:@"%@",[[pass objectForKey:@"user"] objectForKey:@"id"]] isEqualToString:[V5_UserModel uid]]) {
            isMine = YES;
        }
    }
    if (isMine) {
        CourseCommentViewController *vc = [[CourseCommentViewController alloc] init];
        vc.isComment = !_cellType;
        vc.courseId = _courseId;
        vc.originCommentInfo = pass;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        CourseCommentDetailVC *vc = [[CourseCommentDetailVC alloc] init];
        vc.cellType = _cellType;
        vc.topCellInfo = pass;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    return;
    
//    NSDictionary *pass = [NSDictionary dictionaryWithDictionary:_dataSource[indexPath.row]];
//    BOOL isMine = NO;
//    if (SWNOTEmptyDictionary(pass)) {
//        if ([[NSString stringWithFormat:@"%@",[[pass objectForKey:@"user"] objectForKey:@"id"]] isEqualToString:[V5_UserModel uid]]) {
//            isMine = YES;
//        }
//    }
//
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    if (isMine) {
//        UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            CourseCommentViewController *vc = [[CourseCommentViewController alloc] init];
//            vc.isComment = !_cellType;
//            vc.courseId = _courseId;
//            vc.originCommentInfo = pass;
//            [self.navigationController pushViewController:vc animated:YES];
//        }];
//        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
//        [alertController addAction:editAction];
//        [alertController addAction:deleteAction];
//    }
//    UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"评论" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        CourseCommentDetailVC *vc = [[CourseCommentDetailVC alloc] init];
//        vc.cellType = _cellType;
//        vc.topCellInfo = pass;
//        [self.navigationController pushViewController:vc animated:YES];
//    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [alertController addAction:commentAction];
//    [alertController addAction:cancelAction];
//    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)replayComment:(CourseCommentCell *)cell {
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:_detailVC ? _detailVC : _vc];
        return;
    }
    
    CourseCommentDetailVC *vc = [[CourseCommentDetailVC alloc] init];
    vc.cellType = _cellType;
    vc.topCellInfo = cell.userCommentInfo;
    [self.navigationController pushViewController:vc animated:YES];
    return;
    
    NSString *isBuy = [NSString stringWithFormat:@"%@",[(_detailVC ? _detailVC.dataSource : _vc.dataSource) objectForKey:@"is_buy"]];
    if ([isBuy isEqualToString:@"1"]) {
        CourseCommentDetailVC *vc = [[CourseCommentDetailVC alloc] init];
        vc.cellType = _cellType;
        vc.topCellInfo = cell.userCommentInfo;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if (_detailVC) {
            [_detailVC showHudInView:_detailVC.view showHint:@"购买后才能点评课程"];
        } else {
            [_vc showHudInView:_vc.view showHint:@"购买后才能点评课程"];
        }
    }
}

- (void)jumpToCommentVC {
    
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:_detailVC ? _detailVC : _vc];
        return;
    }
    
    NSString *isBuy = [NSString stringWithFormat:@"%@",[(_detailVC ? _detailVC.dataSource : _vc.dataSource) objectForKey:@"is_buy"]];
    if ([isBuy isEqualToString:@"1"]) {
        CourseCommentViewController *vc = [[CourseCommentViewController alloc] init];
        vc.isComment = !_cellType;
        vc.courseId = _courseId;
        vc.courseType = [NSString stringWithFormat:@"%@",[(_detailVC ? _detailVC.dataSource : _vc.dataSource) objectForKey:@"course_type"]];
        vc.courseHourseId = [NSString stringWithFormat:@"%@",_detailVC.currentHourseId];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if (_detailVC) {
            [_detailVC showHudInView:_detailVC.view showHint:@"购买后才能点评课程"];
        } else {
            if (_vc) {
                [_vc showHudInView:_vc.view showHint:@"购买后才能点评课程"];
            }
        }
    }
}

- (void)editContent:(CourseCommentCell *)cell {
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:_detailVC ? _detailVC : _vc];
        return;
    }
    CourseCommentViewController *vc = [[CourseCommentViewController alloc] init];
    vc.isComment = !_cellType;
    vc.courseId = _courseId;
    vc.originCommentInfo = cell.userCommentInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)zanComment:(CourseCommentCell *)cell {
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:_detailVC ? _detailVC : _vc];
        return;
    }
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
            if (_detailVC) {
                [_detailVC showHudInView:_detailVC.view showHint:[responseObject objectForKey:@"msg"]];
            } else {
                [_vc showHudInView:_vc.view showHint:[responseObject objectForKey:@"msg"]];
            }
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
                
                if (SWNOTEmptyArr(_my_dataSource)) {
                    NSMutableDictionary *my_commentInfo = [NSMutableDictionary dictionaryWithDictionary:_my_dataSource[0]];
                    if ([[my_commentInfo allKeys] count]) {
                        if ([[NSString stringWithFormat:@"%@",[my_commentInfo objectForKey:@"id"]] isEqualToString:commentId]) {
                            [my_commentInfo setObject:zanCount forKey:@"like_count"];
                            [my_commentInfo setObject:@(!likeStatus) forKey:@"like"];
                            [_my_dataSource replaceObjectAtIndex:0 withObject:my_commentInfo];
                        }
                    }
                }
                
                
                
                if (SWNOTEmptyArr(_dataSource)) {
                    for (int i = 0; i<_dataSource.count; i++) {
                        NSMutableDictionary *pass = [NSMutableDictionary dictionaryWithDictionary:_dataSource[i]];
                        if ([[NSString stringWithFormat:@"%@",[pass objectForKey:@"id"]] isEqualToString:commentId]) {
                            [pass setObject:zanCount forKey:@"like_count"];
                            [pass setObject:@(!likeStatus) forKey:@"like"];
                            [_dataSource replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithDictionary:pass]];
                            break;
                        }
                    }
                }
                
                [_tableView reloadData];
                
//                NSMutableDictionary *allCommentInfoPass = [NSMutableDictionary dictionaryWithDictionary:_allCommentInfo];
//                NSMutableDictionary *dataPass = [NSMutableDictionary dictionaryWithDictionary:[_allCommentInfo objectForKey:@"data"]];
//                NSMutableDictionary *my_commentInfo = [NSMutableDictionary dictionaryWithDictionary:[dataPass objectForKey:@"my_comment"]];
//                if ([[my_commentInfo allKeys] count]) {
//                    if ([[NSString stringWithFormat:@"%@",[my_commentInfo objectForKey:@"id"]] isEqualToString:commentId]) {
//                        [my_commentInfo setObject:zanCount forKey:@"like_count"];
//                        [my_commentInfo setObject:@(!likeStatus) forKey:@"like"];
//                        [dataPass setObject:my_commentInfo forKey:@"my_comment"];
//                    }
//                }
//
//                NSMutableDictionary *listPass = [NSMutableDictionary dictionaryWithDictionary:[dataPass objectForKey:@"list"]];
//                NSMutableArray *listDataArray = [NSMutableArray arrayWithArray:[listPass objectForKey:@"data"]];
//                for (int i = 0; i<listDataArray.count; i++) {
//                    NSMutableDictionary *pass = [NSMutableDictionary dictionaryWithDictionary:listDataArray[i]];
//                    if ([[NSString stringWithFormat:@"%@",[pass objectForKey:@"id"]] isEqualToString:commentId]) {
//                        [pass setObject:zanCount forKey:@"like_count"];
//                        [pass setObject:@(!likeStatus) forKey:@"like"];
//                        [listDataArray replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithDictionary:pass]];
//                        [listPass setObject:[NSArray arrayWithArray:listDataArray] forKey:@"data"];
//                        [dataPass setObject:[NSDictionary dictionaryWithDictionary:listPass] forKey:@"list"];
//                        [allCommentInfoPass setObject:dataPass forKey:@"data"];
//                        _allCommentInfo = [NSDictionary dictionaryWithDictionary:allCommentInfoPass];
//                        break;
//                    }
//                }
//                [_dataSource removeAllObjects];
//                if (_headerView.showOwnButton.selected) {
//                    if (SWNOTEmptyDictionary([[_allCommentInfo objectForKey:@"data"] objectForKey:@"my_comment"])) {
//                        if ([[[_allCommentInfo objectForKey:@"data"] objectForKey:@"my_comment"] allKeys].count) {
//                            [_dataSource addObject:[[_allCommentInfo objectForKey:@"data"] objectForKey:@"my_comment"]];
//                        }
//                    }
//                } else {
//                    [_dataSource addObjectsFromArray:[[[_allCommentInfo objectForKey:@"data"] objectForKey:@"list"] objectForKey:@"data"]];
//                }
//                [_tableView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        if (_detailVC) {
            [_detailVC showHudInView:_detailVC.view showHint:[[cell.userCommentInfo objectForKey:@"like"] boolValue] ? @"取消点赞失败" : @"点赞失败"];
        } else {
            [_vc showHudInView:_vc.view showHint:[[cell.userCommentInfo objectForKey:@"like"] boolValue] ? @"取消点赞失败" : @"点赞失败"];
        }
    }];
}

- (void)showOwnCommentList:(UIButton *)sender {
    if (_cellType) {
        [self getNoteList];
    } else {
        [self getCourseCommentList];
//        if (SWNOTEmptyDictionary(_allCommentInfo)) {
//            [_dataSource removeAllObjects];
//            if (sender.selected) {
//                if (SWNOTEmptyDictionary([[_allCommentInfo objectForKey:@"data"] objectForKey:@"my_comment"])) {
//                    if ([[[_allCommentInfo objectForKey:@"data"] objectForKey:@"my_comment"] allKeys].count) {
//                        [_dataSource addObject:[[_allCommentInfo objectForKey:@"data"] objectForKey:@"my_comment"]];
//                    }
//                }
//            } else {
//                [_dataSource addObjectsFromArray:[[[_allCommentInfo objectForKey:@"data"] objectForKey:@"list"] objectForKey:@"data"]];
//            }
//            [_tableView reloadData];
//        }
    }
}

- (void)getCourseCommentList {
    if (SWNOTEmptyStr(_courseId)) {
        page = 1;
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:@(page) forKey:@"page"];
        [param setObject:@"10" forKey:@"count"];
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseCommentList:_courseId] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    _allCommentInfo = [NSDictionary dictionaryWithDictionary:responseObject];
                    [_dataSource removeAllObjects];
                    [_my_dataSource removeAllObjects];
                    if (SWNOTEmptyDictionary([[_allCommentInfo objectForKey:@"data"] objectForKey:@"my_comment"])) {
                        if ([[[_allCommentInfo objectForKey:@"data"] objectForKey:@"my_comment"] allKeys].count) {
                            [_my_dataSource addObject:[[_allCommentInfo objectForKey:@"data"] objectForKey:@"my_comment"]];
                        }
                    }
                    [_dataSource addObjectsFromArray:[[[responseObject objectForKey:@"data"] objectForKey:@"list"] objectForKey:@"data"]];
                    if (_dataSource.count<10) {
                        _tableView.mj_footer.hidden = YES;
                    } else {
                        _tableView.mj_footer.hidden = NO;
                        [_tableView.mj_footer setState:MJRefreshStateIdle];
                    }
                    if (_headerView.showOwnButton.selected) {
                        _tableView.mj_footer.hidden = YES;
                    } else {
                        _tableView.mj_footer.hidden = NO;
                    }
                    [_headerView setCourseCommentInfo:[responseObject objectForKey:@"data"] commentOrRecord:_cellType];
                    [_headerView changeCommentStatus:[[[responseObject objectForKey:@"data"] objectForKey:@"has_comment"] boolValue]];
                    [_tableView reloadData];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (void)getMoreList {
    if (_cellType) {
        [self getMoreNoteList];
    } else {
        [self getMoreCommentList];
    }
}

- (void)getMoreCommentList {
    page = page + 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseCommentList:_courseId] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                
                if (SWNOTEmptyDictionary([[responseObject objectForKey:@"data"] objectForKey:@"my_comment"])) {
                    if ([[[_allCommentInfo objectForKey:@"data"] objectForKey:@"my_comment"] allKeys].count) {
                        [_my_dataSource addObject:[[responseObject objectForKey:@"data"] objectForKey:@"my_comment"]];
                    }
                }
                [_dataSource addObjectsFromArray:[[[responseObject objectForKey:@"data"] objectForKey:@"list"] objectForKey:@"data"]];
                
                NSArray *pass = [NSArray arrayWithArray:[[[responseObject objectForKey:@"data"] objectForKey:@"list"] objectForKey:@"data"]];
                if (pass.count<10) {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }
                if (_headerView.showOwnButton.selected) {
                    _tableView.mj_footer.hidden = YES;
                } else {
                    _tableView.mj_footer.hidden = NO;
                }
                [_headerView setCourseCommentInfo:[responseObject objectForKey:@"data"] commentOrRecord:_cellType];
                [_headerView changeCommentStatus:[[[responseObject objectForKey:@"data"] objectForKey:@"has_comment"] boolValue]];
                [_tableView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        page--;
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)getNoteList {
    if (SWNOTEmptyStr(_courseHourseId)) {
        page = 1;
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:@(page) forKey:@"page"];
        [param setObject:@"10" forKey:@"count"];
        [param setObject:_courseHourseId forKey:@"section_id"];
        [param setObject:_headerView.showOwnButton.selected ? @"my" : @"all" forKey:@"type"];
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseHourseNoteList] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
//                    _allCommentInfo = [NSDictionary dictionaryWithDictionary:responseObject];
                    [_dataSource removeAllObjects];
                    [_dataSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
//                    [_headerView setCourseCommentInfo:[responseObject objectForKey:@"data"] commentOrRecord:_cellType];
//                    [_headerView changeCommentStatus:[[[responseObject objectForKey:@"data"] objectForKey:@"has_comment"] boolValue]];
                    if (_dataSource.count<10) {
                        _tableView.mj_footer.hidden = YES;
                    } else {
                        _tableView.mj_footer.hidden = NO;
                        [_tableView.mj_footer setState:MJRefreshStateIdle];
                    }
                    [_tableView reloadData];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (void)getMoreNoteList {
    page = page + 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    [param setObject:_courseHourseId forKey:@"section_id"];
    [param setObject:_headerView.showOwnButton.selected ? @"my" : @"all" forKey:@"type"];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseHourseNoteList] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSArray *pass = [NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                if (pass.count<10) {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [_dataSource addObjectsFromArray:pass];
                [_tableView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        page--;
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
    }];
}

// MARK: - 通知页面刷新数据(发布或者修改笔记、点评 或者点击了新的课时)
- (void)reloadCourseCommentListVCData:(NSNotification *)notice {
    if (SWNOTEmptyDictionary(notice.userInfo)) {
        if ([[notice.userInfo objectForKey:@"type"] isEqualToString:@"comment"]) {
            if (!_cellType) {
                [self getCourseCommentList];
            }
        } else {
            if (_cellType) {
                _courseHourseId = _detailVC.currentHourseId;
                [self getNoteList];
            }
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
