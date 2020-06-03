//
//  CourseCommentDetailVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/18.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseCommentDetailVC.h"
#import "CourseCommentCell.h"
#import "CommentBaseView.h"
#import "Net_Path.h"
#import "UserModel.h"

@interface CourseCommentDetailVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CommentBaseViewDelegate,CourseCommentCellDelegate> {
    CGFloat keyHeight;
    NSInteger page;
    NSString *replayUserId;
}

@property (strong, nonatomic) UILabel *replayCountLabel;
@property (strong, nonatomic) CommentBaseView *commentView;
@property (strong, nonatomic) UIView *commentBackView;

@end

@implementation CourseCommentDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    replayUserId = @"";
    
    if (!SWNOTEmptyStr(_commentId)) {
        if (SWNOTEmptyDictionary(_topCellInfo)) {
            _commentId = [NSString stringWithFormat:@"%@",[_topCellInfo objectForKey:@"id"]];
        }
    }
    
    page = 1;
    
    _titleImage.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"评论";
    _titleLabel.textColor = EdlineV5_Color.textFirstColor;
    [_leftButton setImage:Image(@"nav_back_grey") forState:0];
    _dataSource = [NSMutableArray new];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - CommenViewHeight - MACRO_UI_SAFEAREA)];
    if (_cellType) {
        _tableView.frame = CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_SAFEAREA);
    }
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCommentReplayList)];
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    
    _commentView = [[CommentBaseView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - CommenViewHeight - MACRO_UI_SAFEAREA, MainScreenWidth, CommenViewHeight + MACRO_UI_SAFEAREA)];
    _commentView.delegate = self;
    _commentView.hidden = _cellType;
    [self.view addSubview:_commentView];
    
    _commentBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.001)];
    _commentBackView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.7];
    UITapGestureRecognizer *backViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentBackViewTap:)];
    [_commentBackView addGestureRecognizer:backViewTap];
    _commentBackView.hidden = YES;
    [self.view addSubview:_commentBackView];
    
    [_tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_cellType) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return _dataSource.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *reuse = @"CourseCommentCell";
        CourseCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[CourseCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse cellType:_cellType];
        }
        cell.delegate = self;
        [cell setCommentInfo:_topCellInfo showAllContent:_cellType];
        cell.commentCountButton.hidden = YES;
        cell.editButton.hidden = YES;
        return cell;
    } else {
        static NSString *reuse = @"CourseCommentReplayCell";
        CourseCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[CourseCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse cellType:_cellType];
        }
        cell.delegate = self;
        [cell setCommentInfo:_dataSource[indexPath.row] showAllContent:_cellType];
        cell.scoreStar.hidden = YES;
        cell.commentCountButton.hidden = YES;
        cell.commentOrReplay = YES;
        cell.editButton.hidden = YES;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else if (section == 1) {
        UIView *headerSetion = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 42)];
        headerSetion.backgroundColor = [UIColor whiteColor];
        if (!_replayCountLabel) {
            _replayCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 150, 22)];
            _replayCountLabel.textColor = EdlineV5_Color.textFirstColor;
            _replayCountLabel.font = SYSTEMFONT(16);
        }
        
        _replayCountLabel.text = [NSString stringWithFormat:@"共%@条回复",SWNOTEmptyDictionary(_commentInfo) ? [[_commentInfo objectForKey:@"commentReply"] objectForKey:@"total"] : @"0"];
        [headerSetion addSubview:_replayCountLabel];
        return headerSetion;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.001;
    } else if (section == 1) {
        return 42;
    }
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    replayUserId = @"";
    if (indexPath.section == 0) {
        return;
    }
    NSDictionary *pass = [NSDictionary dictionaryWithDictionary:_dataSource[indexPath.row]];
    BOOL isMine = NO;
    if (SWNOTEmptyDictionary(pass)) {
        if ([[NSString stringWithFormat:@"%@",[[pass objectForKey:@"user"] objectForKey:@"id"]] isEqualToString:[UserModel uid]]) {
            isMine = YES;
        }
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (isMine) {
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:deleteAction];
    } else {
        UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"回复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            replayUserId = [NSString stringWithFormat:@"%@",[[pass objectForKey:@"user"] objectForKey:@"id"]];
            [_commentView.inputTextView becomeFirstResponder];
            _commentView.placeHoderLab.text = [NSString stringWithFormat:@"回复@%@",[[pass objectForKey:@"user"] objectForKey:@"nick_name"]];
            }];
        [alertController addAction:commentAction];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 42;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0)
    {
        scrollView.contentInset = UIEdgeInsetsMake(- scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y >= sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(- sectionHeaderHeight, 0, 0, 0);
    }
}

- (void)textViewValueDidChanged:(NSNotification *)notice {
    UITextView *textView = (UITextView *)notice.object;
    if (textView.text.length<=0) {
        _commentView.placeHoderLab.hidden = NO;
    } else {
        _commentView.placeHoderLab.hidden = YES;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification{
    [_commentView setTop:MainScreenHeight - MACRO_UI_SAFEAREA - CommenViewHeight];
    [_commentView setHeight:CommenViewHeight + MACRO_UI_SAFEAREA];
    [_commentView.inputTextView setHeight:CommentInputHeight];
    [_commentBackView setHeight:0.001];
    _commentBackView.hidden = YES;
    if (_commentView.inputTextView.text.length<=0) {
        _commentView.placeHoderLab.hidden = NO;
    } else {
        _commentView.placeHoderLab.hidden = YES;
    }
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

- (void)commentBackViewTap:(UIGestureRecognizer *)tap {
    [_commentView.inputTextView resignFirstResponder];
}

// MARK: - 点赞代理
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
    if (cell.commentOrReplay) {
        [Net_API requestPUTWithURLStr:[Net_Path zanCommentReplay:commentId] paramDic:param Api_key:nil finish:^(id  _Nonnull responseObject) {
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
                    
                    NSMutableDictionary *allCommentInfoPass = [NSMutableDictionary dictionaryWithDictionary:_commentInfo];
                    NSMutableDictionary *listPass = [NSMutableDictionary dictionaryWithDictionary:[allCommentInfoPass objectForKey:@"commentReply"]];
                    NSMutableArray *listDataArray = [NSMutableArray arrayWithArray:[listPass objectForKey:@"data"]];
                    for (int i = 0; i<listDataArray.count; i++) {
                        NSMutableDictionary *pass = [NSMutableDictionary dictionaryWithDictionary:listDataArray[i]];
                        if ([[NSString stringWithFormat:@"%@",[pass objectForKey:@"id"]] isEqualToString:commentId]) {
                            [pass setObject:zanCount forKey:@"like_count"];
                            [pass setObject:@(!likeStatus) forKey:@"like"];
                            [listDataArray replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithDictionary:pass]];
                            [listPass setObject:[NSArray arrayWithArray:listDataArray] forKey:@"data"];
                            [allCommentInfoPass setObject:listPass forKey:@"commentReply"];
                            _commentInfo = [NSDictionary dictionaryWithDictionary:allCommentInfoPass];
                            break;
                        }
                    }
                    
                    [_dataSource removeAllObjects];
                    [_dataSource addObjectsFromArray:[[_commentInfo objectForKey:@"commentReply"] objectForKey:@"data"]];
                    [_tableView reloadData];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            [self showHudInView:self.view showHint:[[cell.userCommentInfo objectForKey:@"like"] boolValue] ? @"取消点赞失败" : @"点赞失败"];
        }];
    } else {
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
                    NSMutableDictionary *allCommentInfoPass = [NSMutableDictionary dictionaryWithDictionary:_commentInfo];
                    NSMutableDictionary *my_commentInfo = [NSMutableDictionary dictionaryWithDictionary:[allCommentInfoPass objectForKey:@"comment"]];
                    if ([[my_commentInfo allKeys] count]) {
                        if ([[NSString stringWithFormat:@"%@",[my_commentInfo objectForKey:@"id"]] isEqualToString:commentId]) {
                            [my_commentInfo setObject:zanCount forKey:@"like_count"];
                            [my_commentInfo setObject:@(!likeStatus) forKey:@"like"];
                            [allCommentInfoPass setObject:my_commentInfo forKey:@"comment"];
                        }
                    }
                    _commentInfo = [NSDictionary dictionaryWithDictionary:allCommentInfoPass];
                    _topCellInfo = [NSDictionary dictionaryWithDictionary:[_commentInfo objectForKey:@"comment"]];
                    [_tableView reloadData];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            [self showHudInView:self.view showHint:[[cell.userCommentInfo objectForKey:@"like"] boolValue] ? @"取消点赞失败" : @"点赞失败"];
        }];
    }
}

- (void)sendReplayMsg:(CommentBaseView *)view {
    [view.inputTextView resignFirstResponder];
    if (!SWNOTEmptyStr(view.inputTextView.text)) {
        [self showHudInView:self.view showHint:@"请输入评论内容"];
        return;
    }
    NSString *content = [NSString stringWithFormat:@"%@",view.inputTextView.text];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:content forKey:@"content"];
    [param setObject:SWNOTEmptyStr(replayUserId) ? replayUserId : @"0" forKey:@"reply_uid"];
    [Net_API requestPOSTWithURLStr:[Net_Path courseCommentReplayList:_commentId] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                replayUserId = @"";
                _commentView.placeHoderLab.text = @"评论";
            }
        }
    } enError:^(NSError * _Nonnull error) {
        [self showHudInView:self.view showHint:@"评论失败"];
    }];
    view.inputTextView.text = @"";
    view.placeHoderLab.hidden = NO;
}

- (void)getCommentReplayList {
    if (_cellType) {
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header endRefreshing];
        }
        return;
    }
    if (SWNOTEmptyStr(_commentId)) {
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:@(page) forKey:@"page"];
        [param setObject:@"10" forKey:@"count"];
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseCommentReplayList:_commentId] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    _topCellInfo = [NSDictionary dictionaryWithDictionary:[[responseObject objectForKey:@"data"] objectForKey:@"comment"]];
                    [_dataSource removeAllObjects];
                    [_dataSource addObjectsFromArray:[[[responseObject objectForKey:@"data"] objectForKey:@"commentReply"] objectForKey:@"data"]];
                    _commentInfo = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                    [_tableView reloadData];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
        }];
    } else {
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header endRefreshing];
        }
    }
}

@end
