//
//  QuestionAnswerReplyListViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/4/13.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "QuestionAnswerReplyListViewController.h"
#import "V5_Constant.h"
#import "QuestionAnswerCell.h"
#import "QuestionAnswerReplyListCell.h"
#import "Net_Path.h"
#import "CommentBaseView.h"

@interface QuestionAnswerReplyListViewController ()<UITableViewDelegate, UITableViewDataSource, QuestionAnswerCellDelegate, ZLPhotoPickerBrowserViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDataSource,CommentBaseViewDelegate> {
    NSInteger page;
    UIImageView *currentShowPicImageView;
    CGFloat keyHeight;
}

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *currentShowPicArray;

@property (strong, nonatomic) UILabel *replayCountLabel;
@property (strong, nonatomic) CommentBaseView *commentView;
@property (strong, nonatomic) UIView *commentBackView;

@end

@implementation QuestionAnswerReplyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"问题回答详情页";
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _rightButton.hidden = NO;
    [_rightButton setImage:Image(@"nav_more_white_QD") forState:0];
    _lineTL.hidden = NO;
    _lineTL.backgroundColor = EdlineV5_Color.layarLineColor;
    _dataSource = [NSMutableArray new];
    _currentShowPicArray = [NSMutableArray new];
    [_currentShowPicArray addObjectsFromArray:@[DefaultImage,DefaultImage,DefaultImage,DefaultImage,DefaultImage]];
    page = 1;
    [self makeTableView];
    
    // 键盘相关通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - CommenViewHeight - MACRO_UI_SAFEAREA)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getFirstList)];
//    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreList)];
//    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
//    [_tableView.mj_header beginRefreshing];
    
    
    _commentView = [[CommentBaseView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - CommenViewHeight - MACRO_UI_SAFEAREA, MainScreenWidth, CommenViewHeight + MACRO_UI_SAFEAREA) leftButtonImageArray:nil placeHolderTitle:nil sendButtonTitle:@"发布"];
    _commentView.delegate = self;
    [_commentView.sendButton setTitleColor:HEXCOLOR(0x5191FF) forState:0];
    [self.view addSubview:_commentView];
    
    _commentBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.001)];
    _commentBackView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.7];
    UITapGestureRecognizer *backViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentBackViewTap:)];
    [_commentBackView addGestureRecognizer:backViewTap];
    _commentBackView.hidden = YES;
    [self.view addSubview:_commentBackView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 8;//_dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *reuse = @"QuestionAnswerCell";
        QuestionAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[QuestionAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setQuestionAnswerDetailListCellInfo:@{}];
        return cell;
    }
    static NSString *reuse = @"QuestionAnswerReplyListCell";
    QuestionAnswerReplyListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[QuestionAnswerReplyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setQuestionAnswerCommentInfo:@{} showAllContent:NO];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)getFirstList {
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    // 大类型
    if (SWNOTEmptyStr(_courseType)) {
        [param setObject:_courseType forKey:@"source_type"];
    }
    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path userCollectionListNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
//                [_dataSource addObjectsFromArray:[ShopCarCourseModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]]];
                if (_dataSource.count<10) {
                    _tableView.mj_footer.hidden = YES;
                } else {
                    _tableView.mj_footer.hidden = NO;
                    [_tableView.mj_footer setState:MJRefreshStateIdle];
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

- (void)getMoreList {
    page = page + 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    // 大类型
    if (SWNOTEmptyStr(_courseType)) {
        [param setObject:_courseType forKey:@"source_type"];
    }
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path userCollectionListNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSArray *pass = [NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
//                NSArray *pass = [NSArray arrayWithArray:[ShopCarCourseModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]]];
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

- (void)showPic:(NSDictionary *)dict imagetag:(NSInteger)tag toView:(nonnull UIImageView *)toImageView {
    currentShowPicImageView = toImageView;
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    pickerBrowser.delegate = self;
    pickerBrowser.dataSource = self;
    pickerBrowser.editing = NO;
    pickerBrowser.currentIndexPath = [NSIndexPath indexPathForRow:tag inSection:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [pickerBrowser showPickerVc:window.rootViewController];
    });
}

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return _currentShowPicArray.count;
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:_currentShowPicArray[indexPath.row]];
//    NSString *imageURLStr;
//    // 如果没有原图，会拿到一个null字符串，注意是字符串
//    if (![self.originalImageArray[indexPath.row] isEqualToString:@"null"]) {
//        imageURLStr = self.originalImageArray[indexPath.row];
//    }
//    else{
//        imageURLStr = _webImageUrlStrArray[indexPath.row];
//    }
//    photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:[NSURL URLWithString:imageURLStr]];
//    photo.toView = currentShowPicImageView;
    return photo;
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
    CGFloat XX = SWNOTEmptyArr(_commentView.leftButtonImageArray) ? (15 + _commentView.leftButtonImageArray.count * (CommentViewLeftButtonWidth + 8) + 13.5 - 8) : 15;
    _commentView.inputTextView.frame = CGRectMake(XX, (CommenViewHeight - CommentInputHeight) / 2.0, MainScreenWidth - XX - 57.5, CommentInputHeight);
    for (int i = 0; i<self.commentView.leftButtonImageArray.count; i++) {
        UIButton *btn = (UIButton *)[_commentView viewWithTag:20 + i];
        btn.hidden = NO;
    }
    [_commentView.sendButton setTop:0];
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
    if (IS_IPHONEX) {
        keyHeight = keyHeight - 34;
    }
    [UIView animateWithDuration:0.1 animations:^{
        for (int i = 0; i<self.commentView.leftButtonImageArray.count; i++) {
            UIButton *btn = (UIButton *)[self.commentView viewWithTag:20 + i];
            btn.hidden = YES;
        }
        [self.commentView setHeight:CommentViewMaxHeight];
        self.commentView.inputTextView.frame = CGRectMake(15, (CommenViewHeight - CommentInputHeight) / 2.0, MainScreenWidth - 15 - 57.5, CommentViewMaxHeight - (CommenViewHeight - CommentInputHeight));
        [self.commentView.sendButton setTop:self.commentView.inputTextView.bottom - CommenViewHeight + (CommenViewHeight - CommentInputHeight)/2.0];
        [self.commentView setTop:MainScreenHeight - MACRO_UI_SAFEAREA - CommentViewMaxHeight - self->keyHeight];
        [self.commentBackView setHeight:MainScreenHeight - MACRO_UI_SAFEAREA - CommentViewMaxHeight - self->keyHeight];
    } completion:^(BOOL finished) {
        self.commentBackView.hidden = NO;
    }];
}

// MARK: - 评论框点击事件
- (void)commentBackViewTap:(UIGestureRecognizer *)tap {
    [_commentView.inputTextView resignFirstResponder];
}

// MARK: - 评论框点击发布按钮事件
- (void)sendReplayMsg:(CommentBaseView *)view {
    [view.inputTextView resignFirstResponder];
    if (!SWNOTEmptyStr(view.inputTextView.text)) {
        [self showHudInView:self.view showHint:@"请输入评论内容"];
        return;
    }
//    NSString *content = [NSString stringWithFormat:@"%@",view.inputTextView.text];
//    NSMutableDictionary *param = [NSMutableDictionary new];
//    [param setObject:content forKey:@"content"];
//    [param setObject:SWNOTEmptyStr(replayUserId) ? replayUserId : @"0" forKey:@"reply_user_id"];
//    [Net_API requestPOSTWithURLStr:[Net_Path zixunPostCommentReplay:_commentId] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
//        if (SWNOTEmptyDictionary(responseObject)) {
//            [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
//            if ([[responseObject objectForKey:@"code"] integerValue]) {
//                replayUserId = @"";
//                _commentView.placeHoderLab.text = @"评论";
//                [self getCommentReplayList];
//            }
//        }
//    } enError:^(NSError * _Nonnull error) {
//        [self showHudInView:self.view showHint:@"评论失败"];
//    }];
    view.inputTextView.text = @"";
    view.placeHoderLab.hidden = NO;
}

@end
