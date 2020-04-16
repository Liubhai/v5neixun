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

@interface CourseCommentDetailVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CommentBaseViewDelegate> {
    CGFloat keyHeight;
    NSInteger page;
}

@property (strong, nonatomic) UILabel *replayCountLabel;
@property (strong, nonatomic) CommentBaseView *commentView;
@property (strong, nonatomic) UIView *commentBackView;

@end

@implementation CourseCommentDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 50 - MACRO_UI_SAFEAREA)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCommentReplayList)];
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    
    _commentView = [[CommentBaseView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - CommenViewHeight - MACRO_UI_SAFEAREA, MainScreenWidth, CommenViewHeight + MACRO_UI_SAFEAREA)];
    _commentView.delegate = self;
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
        cell.commentCountButton.hidden = YES;
        [cell setCommentInfo:_topCellInfo];
        return cell;
    } else {
        static NSString *reuse = @"CourseCommentReplayCell";
        CourseCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[CourseCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse cellType:_cellType];
        }
        cell.scoreStar.hidden = YES;
        cell.commentCountButton.hidden = YES;
        [cell setCommentInfo:_dataSource[indexPath.row]];
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
        
        _replayCountLabel.text = [NSString stringWithFormat:@"共%@条回复",[[_commentInfo objectForKey:@"commentReply"] objectForKey:@"total"]];
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

- (void)sendReplayMsg:(CommentBaseView *)view {
    [view.inputTextView resignFirstResponder];
    if (!SWNOTEmptyStr(view.inputTextView.text)) {
        [self showHudInView:self.view showHint:@"请输入评论内容"];
        return;
    }
    NSString *content = [NSString stringWithFormat:@"%@",view.inputTextView.text];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:content forKey:@"description"];
    // 目前没有做回复评论
    [param setObject:@"0" forKey:@"reply_uid"];
    [Net_API requestPOSTWithURLStr:[Net_Path courseCommentReplayList:_commentId] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
        }
    } enError:^(NSError * _Nonnull error) {
        [self showHudInView:self.view showHint:@"评论失败"];
    }];
    view.inputTextView.text = @"";
    view.placeHoderLab.hidden = NO;
}

- (void)getCommentReplayList {
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
