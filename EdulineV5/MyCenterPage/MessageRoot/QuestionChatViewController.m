//
//  QuestionChatViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/8/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "QuestionChatViewController.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "UserModel.h"
#import "CommentBaseView.h"
#import "QuestionChatRightCell.h"
#import "QuestionChatLeftCell.h"
#import "QuestionChatTimeCell.h"

@interface QuestionChatViewController ()<UITableViewDelegate, UITableViewDataSource, CommentBaseViewDelegate> {
    NSInteger page;
    NSString *reply_user_id;
    CGFloat keyHeight;
    BOOL isScrollBottom;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UIView *headView;
@property (strong, nonatomic) UIView *quesrionContentBackView;
@property (strong, nonatomic) UILabel *quesrionContentLabel;


@property (strong, nonatomic) CommentBaseView *commentView;
@property (strong, nonatomic) UIView *commentBackView;


@end

@implementation QuestionChatViewController

- (void)viewDidAppear {
    isScrollBottom = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    isScrollBottom = YES;
    reply_user_id = @"";
    page = 0;
    _dataSource = [NSMutableArray new];
    if (SWNOTEmptyDictionary(_questionInfo)) {
        _titleLabel.text = [NSString stringWithFormat:@"%@",_questionInfo[@"send_user_nick_name"]];
        reply_user_id = [NSString stringWithFormat:@"%@",_questionInfo[@"send_user_id"]];
    }
    [self makeHeaderView];
    [self makeTableView];
    [self makeBottomView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)makeHeaderView {
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 23 + 22)];
    _headView.backgroundColor = EdlineV5_Color.backColor;
    
    _quesrionContentBackView = [[UIView alloc] initWithFrame:CGRectMake(15, 23, MainScreenWidth - 30, 22 + 20)];
    _quesrionContentBackView.backgroundColor = HEXCOLOR(0xF0F0F0);
    [_headView addSubview:_quesrionContentBackView];
    
    _quesrionContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, _quesrionContentBackView.width - 20, 22)];
    _quesrionContentLabel.font = SYSTEMFONT(13);
    _quesrionContentLabel.textColor = EdlineV5_Color.textThirdColor;
    _quesrionContentLabel.numberOfLines = 0;
    _quesrionContentLabel.backgroundColor = HEXCOLOR(0xF0F0F0);
//    if (SWNOTEmptyDictionary(_questionInfo)) {
////        _quesrionContentLabel.text = [NSString stringWithFormat:@"问题内容：%@",_questionInfo[@"notify_data"][@"content"]];
//        _quesrionContentLabel.text = [NSString stringWithFormat:@"问题内容：%@",_questionInfo[@"content"]];
//    }
    [_quesrionContentBackView addSubview:_quesrionContentLabel];
    [_quesrionContentLabel sizeToFit];
    [_quesrionContentLabel setHeight:_quesrionContentLabel.height];
    [_quesrionContentLabel setWidth:_quesrionContentBackView.width - 20];
    [_quesrionContentBackView setHeight:_quesrionContentLabel.bottom + 10];
    [_headView setHeight:_quesrionContentBackView.bottom + 23];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_TABBAR_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = EdlineV5_Color.backColor;;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getFirstList)];
//    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreList)];
//    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = _headView;
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    [_tableView.mj_header beginRefreshing];
}

- (void)makeBottomView {
    _commentView = [[CommentBaseView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - CommenViewHeight - MACRO_UI_SAFEAREA, MainScreenWidth, CommenViewHeight + MACRO_UI_SAFEAREA)];
    _commentView.delegate = self;
    _commentView.placeHoderLab.hidden = YES;
    [self.view addSubview:_commentView];
    
    _commentBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.001)];
    _commentBackView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.7];
    UITapGestureRecognizer *backViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentBackViewTap:)];
    [_commentBackView addGestureRecognizer:backViewTap];
    _commentBackView.hidden = YES;
    [self.view addSubview:_commentBackView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isScrollBottom) { //只在初始化的时候执行
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.dataSource.count > 0) {
               NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.tableView numberOfRowsInSection:0]-1) inSection:0];
               [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
       });
    }
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"user_id"]] isEqualToString:[UserModel uid]]) {
        static NSString *rightReuse = @"QuestionChatRightCell";
        QuestionChatRightCell *cell = [tableView dequeueReusableCellWithIdentifier:rightReuse];
        if (!cell) {
            cell = [[QuestionChatRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightReuse];
        }
        [cell setQuestionChatRightInfo:_dataSource[indexPath.row]];
        return cell;
    } else {
        static NSString *rightReuse = @"QuestionChatLeftCell";
        QuestionChatLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:rightReuse];
        if (!cell) {
            cell = [[QuestionChatLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightReuse];
        }
        [cell setQuestionChatLeftInfo:_dataSource[indexPath.row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)keyboardWillHide:(NSNotification *)notification{
    [_commentView setTop:MainScreenHeight - MACRO_UI_SAFEAREA - CommenViewHeight];
    [_commentView setHeight:CommenViewHeight + MACRO_UI_SAFEAREA];
    [_commentView.inputTextView setHeight:CommentInputHeight];
    [_commentBackView setHeight:0.001];
    _commentBackView.hidden = YES;
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSValue * endValue   = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyHeight = [endValue CGRectValue].size.height;
    [UIView animateWithDuration:0.1 animations:^{
        [self.commentView setHeight:CommentViewMaxHeight];
        [self.commentView.inputTextView setHeight:CommentViewMaxHeight - (CommenViewHeight - CommentInputHeight)];
        [self.commentView setTop:MainScreenHeight - MACRO_UI_SAFEAREA - CommentViewMaxHeight - self->keyHeight];
        [self.commentBackView setHeight:MainScreenHeight - MACRO_UI_SAFEAREA - CommentViewMaxHeight - self->keyHeight];
    } completion:^(BOOL finished) {
        self.commentBackView.hidden = NO;
    }];
}

// MARK: - 发送内容
- (void)sendReplayMsg:(CommentBaseView *)view {
    [view.inputTextView resignFirstResponder];
    if (!SWNOTEmptyStr(view.inputTextView.text)) {
        [self showHudInView:self.view showHint:@"请输入内容"];
        return;
    }
    if (!SWNOTEmptyStr(reply_user_id)) {
        return;
    }
    NSString *content = [NSString stringWithFormat:@"%@",view.inputTextView.text];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:content forKey:@"content"];
    [param setObject:_questionId forKey:@"question_id"];
    [param setObject:reply_user_id forKey:@"reply_user_id"];
    [Net_API requestPOSTWithURLStr:[Net_Path questionReplayNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [self getFirstPageList];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        [self showHudInView:self.view showHint:@"发送失败"];
    }];
    view.inputTextView.text = @"";
}

- (void)commentBackViewTap:(UIGestureRecognizer *)tap {
    [_commentView.inputTextView resignFirstResponder];
}

- (void)getFirstList {
    page = page + 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path questionChatListNet:_questionId] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                if (page == 1) {
                    [_dataSource removeAllObjects];
                }
                _quesrionContentLabel.text = [NSString stringWithFormat:@"问题内容：%@",[[responseObject objectForKey:@"data"] objectForKey:@"content"]];
                [_quesrionContentLabel sizeToFit];
                [_quesrionContentLabel setHeight:_quesrionContentLabel.height];
                [_quesrionContentLabel setWidth:_quesrionContentBackView.width - 20];
                [_quesrionContentBackView setHeight:_quesrionContentLabel.bottom + 10];
                [_headView setHeight:_quesrionContentBackView.bottom + 23];
                NSArray *pass = [NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"reply"]];
                [_dataSource insertObjects:pass atIndex:0];
                if (pass.count<10) {
                    _tableView.mj_header.hidden = YES;
                } else {
                    _tableView.mj_header.hidden = NO;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [CATransaction setDisableActions:YES];

                    [_tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];

                    [CATransaction commit];
                });
            }
        }
    } enError:^(NSError * _Nonnull error) {
        page--;
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
    }];
}

// MARK: - 回复消息后请求第一页数据
- (void)getFirstPageList {
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path questionChatListNet:_questionId] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"reply"]];
                if (_dataSource.count<10) {
                    _tableView.mj_header.hidden = YES;
                } else {
                    _tableView.mj_header.hidden = NO;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [CATransaction setDisableActions:YES];

                    [_tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];

                    [CATransaction commit];
                });
            }
        }
    } enError:^(NSError * _Nonnull error) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
    }];
}

- (void)getMoreList {
    page = page + 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path questionChatListNet:_questionId] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSArray *pass = [NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"reply"]];
                if (pass.count<10) {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [_dataSource addObjectsFromArray:pass];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [CATransaction setDisableActions:YES];

                    [_tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];

                    [CATransaction commit];
                });
            }
        }
    } enError:^(NSError * _Nonnull error) {
        page--;
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
    }];
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
