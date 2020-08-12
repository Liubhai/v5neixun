//
//  MessageListVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MessageListVC.h"
#import "MessageListCell.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "MessageDetailVC.h"
#import "CourseMainViewController.h"
#import "ZiXunDetailVC.h"
#import "CourseCommentDetailVC.h"
#import "ZixunCommmentDetailVC.h"
#import "QuestionChatViewController.h"

@interface MessageListVC ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> {
    NSInteger page;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation MessageListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleImage.hidden = YES;
    _dataSource = [NSMutableArray new];
    page = 1;
    [self makeTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFirstData) name:@"reloadMessageList" object:nil];
    // Do any additional setup after loading the view.
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getFirstData)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreDataList)];
    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    [_tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"MessageListCell";
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[MessageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setMessageInfo:_dataSource[indexPath.row] typeString:_courseType];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_courseType isEqualToString:@"course"] || [_courseType isEqualToString:@"system"]) {
        if ([[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"is_link"]] isEqualToString:@"1"]) {
            if ([[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"link_data_type"]] isEqualToString:@"video"]) {
                CourseMainViewController *vc = [[CourseMainViewController alloc] init];
                vc.ID = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"link_data_id"]];
                vc.isLive = NO;
                vc.courseType = @"1";
                [self.navigationController pushViewController:vc animated:YES];
            } else if ([[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"link_data_type"]] isEqualToString:@"live"] || [[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"link_data_type"]] isEqualToString:@"live_small"]) {
                CourseMainViewController *vc = [[CourseMainViewController alloc] init];
                vc.ID = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"link_data_id"]];
                vc.isLive = YES;
                vc.courseType = @"2";
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else {
            MessageDetailVC *vc = [[MessageDetailVC alloc] init];
            vc.info = _dataSource[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if ([_courseType isEqualToString:@"comment"] || [_courseType isEqualToString:@"question"]) {
        /** 1:course;2:topic;3question; */
        NSString *typeS = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"notify_type"]];
        if ([typeS isEqualToString:@"1"]) {
            CourseCommentDetailVC *vc = [[CourseCommentDetailVC alloc] init];
            vc.cellType = NO;
            vc.commentId = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"notify_data"][@"id"]];
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([typeS isEqualToString:@"2"]) {
            ZixunCommmentDetailVC *vc = [[ZixunCommmentDetailVC alloc] init];
            vc.cellType = NO;
            vc.commentId = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"notify_data"][@"id"]];
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([typeS isEqualToString:@"3"]) {
            QuestionChatViewController *vc = [[QuestionChatViewController alloc] init];
            vc.questionId = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"notify_data"][@"id"]];
            vc.questionInfo = [NSDictionary dictionaryWithDictionary:_dataSource[indexPath.row]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    [self setMessageRead:[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"id"]]];
}

- (void)getFirstData {
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    
    NSString *urlS;
    if ([_courseType isEqualToString:@"course"]) {
        urlS = [Net_Path notifyCourseMessageNet];
    } else if ([_courseType isEqualToString:@"comment"]) {
        urlS = [Net_Path notifyCommentMessageNet];
    } else if ([_courseType isEqualToString:@"system"]) {
        urlS = [Net_Path notifySystemMessageNet];
    } else if ([_courseType isEqualToString:@"question"]) {
        urlS = [Net_Path notifyQuestionMessageNet];
    }
    if (!SWNOTEmptyStr(urlS)) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
        return;
    }
    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
    [Net_API requestGETSuperAPIWithURLStr:urlS WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                if (_dataSource.count<10) {
                    _tableView.mj_footer.hidden = YES;
                } else {
                    [_tableView.mj_footer setState:MJRefreshStateIdle];
                    _tableView.mj_footer.hidden = NO;
                }
                [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_tableView.height];
                [_tableView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
    }];
}

- (void)getMoreDataList {
    page = page + 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    NSString *urlS;
    if ([_courseType isEqualToString:@"course"]) {
        urlS = [Net_Path notifyCourseMessageNet];
    } else if ([_courseType isEqualToString:@"comment"]) {
        urlS = [Net_Path notifyCommentMessageNet];
    } else if ([_courseType isEqualToString:@"system"]) {
        urlS = [Net_Path notifySystemMessageNet];
    } else if ([_courseType isEqualToString:@"question"]) {
        urlS = [Net_Path notifyQuestionMessageNet];
    }
    if (SWNOTEmptyStr(urlS)) {
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
        return;
    }
    [Net_API requestGETSuperAPIWithURLStr:urlS WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
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

// MARK: - 处理通知
- (void)reloadData:(NSNotification *)notice {
    if (![[notice.userInfo objectForKey:@"type"] isEqualToString:_courseType]) {
        return;
    }
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    
    NSString *urlS;
    if ([_courseType isEqualToString:@"course"]) {
        urlS = [Net_Path notifyCourseMessageNet];
    } else if ([_courseType isEqualToString:@"comment"]) {
        urlS = [Net_Path notifyCommentMessageNet];
    } else if ([_courseType isEqualToString:@"system"]) {
        urlS = [Net_Path notifySystemMessageNet];
    } else if ([_courseType isEqualToString:@"question"]) {
        urlS = [Net_Path notifyQuestionMessageNet];
    }
    if (!SWNOTEmptyStr(urlS)) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
        return;
    }
    [Net_API requestGETSuperAPIWithURLStr:urlS WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                if (_dataSource.count<10) {
                    _tableView.mj_footer.hidden = YES;
                } else {
                    [_tableView.mj_footer setState:MJRefreshStateIdle];
                    _tableView.mj_footer.hidden = NO;
                }
                [_tableView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
    }];
}

- (void)setMessageRead:(NSString *)messageId {
    if (SWNOTEmptyStr(messageId)) {
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:@"1" forKey:@"operate"];
        if ([_courseType isEqualToString:@"course"]) {
            [param setObject:@"2" forKey:@"object"];
        } else if ([_courseType isEqualToString:@"comment"]) {
            [param setObject:@"3" forKey:@"object"];
        } else if ([_courseType isEqualToString:@"system"]) {
            [param setObject:@"1" forKey:@"object"];
        } else if ([_courseType isEqualToString:@"question"]) {
            [param setObject:@"4" forKey:@"object"];
        }
        [param setObject:messageId forKey:@"id"];
        [Net_API requestPOSTWithURLStr:[Net_Path messageReadNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    [self getFirstData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadAllMessage" object:nil];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
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
