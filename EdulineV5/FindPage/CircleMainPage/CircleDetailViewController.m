//
//  CircleDetailViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/5/31.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "CircleDetailViewController.h"
#import "V5_Constant.h"
#import "V5_UserModel.h"
#import "AppDelegate.h"
#import "Net_Path.h"
#import "CircleListCell.h"
#import "CircleDetailCommentCell.h"
#import "CirclePostViewController.h"

#import "MyCirclePageVC.h"
#import "UserHomePageViewController.h"

@interface CircleDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CircleListCellDelegate,CircleDetailCommentCellDelegate,ZLPhotoPickerBrowserViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDataSource> {
    NSInteger page;
    NSString *replayUserId;
    UIImageView *currentShowPicImageView;
}

@property (strong, nonatomic) UILabel *replayCountLabel;

@property (strong, nonatomic) UIView *commentBackView;
@property (strong, nonatomic) UILabel *commentPlaceLabel;
@property (strong, nonatomic) UIButton *commentButton;

@property (strong, nonatomic) NSMutableArray *currentShowPicArray;

@end

@implementation CircleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    replayUserId = @"";
    
    page = 1;
    
    _titleImage.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"详情";
    _titleLabel.textColor = EdlineV5_Color.textFirstColor;
    
    _lineTL.hidden = NO;
    _lineTL.backgroundColor = EdlineV5_Color.layarLineColor;
    
    _dataSource = [NSMutableArray new];
    _currentShowPicArray = [NSMutableArray new];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - CommenViewHeight - MACRO_UI_SAFEAREA) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCommentReplayList)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreList)];
    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    
    _commentBackView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - CommenViewHeight - MACRO_UI_SAFEAREA, MainScreenWidth, CommenViewHeight + MACRO_UI_SAFEAREA)];
    _commentBackView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    _commentBackView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.06].CGColor;
    _commentBackView.layer.shadowOffset = CGSizeMake(0,1);
    _commentBackView.layer.shadowOpacity = 1;
    _commentBackView.layer.shadowRadius = 7;
    [self.view addSubview:_commentBackView];
    
    _commentPlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, MainScreenWidth - 30, 36)];
    _commentPlaceLabel.text = @"  评论";
    _commentPlaceLabel.textColor = EdlineV5_Color.textFirstColor;
    _commentPlaceLabel.font = SYSTEMFONT(15);
    _commentPlaceLabel.backgroundColor = HEXCOLOR(0xF7F7F7);
    _commentPlaceLabel.layer.masksToBounds = YES;
    _commentPlaceLabel.layer.cornerRadius = _commentPlaceLabel.height / 2.0;
    [_commentBackView addSubview:_commentPlaceLabel];
    
    _commentButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 7, MainScreenWidth - 30, 36)];
    _commentButton.backgroundColor = [UIColor clearColor];
    [_commentButton addTarget:self action:@selector(commentCircleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_commentBackView addSubview:_commentButton];
    
    [_tableView.mj_header beginRefreshing];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCommentReplayList) name:@"commentActionReloadData" object:nil];
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
        static NSString *reuse = @"CircleListCellDetail";
        CircleListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[CircleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setCircleCellInfo:_detailInfo circleType:[NSString stringWithFormat:@"%@",_detailInfo[@"type"]] isDetail:YES];
        cell.delegate = self;
        return cell;
    } else {
        static NSString *reuse = @"CircleDetailCommentCell";
        CircleDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[CircleDetailCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setCommentInfo:_dataSource[indexPath.row] circle_userId:[NSString stringWithFormat:@"%@",_detailInfo[@"user_id"]]];
        cell.delegate = self;
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
        
        _replayCountLabel.text = [NSString stringWithFormat:@"共%@条回复",SWNOTEmptyDictionary(_commentInfo) ? [[_commentInfo objectForKey:@"detail"] objectForKey:@"comment_num"] : @"0"];
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
        if ([[NSString stringWithFormat:@"%@",[pass objectForKey:@"user_id"]] isEqualToString:[V5_UserModel uid]]) {
            isMine = YES;
        }
    }
    if (isMine) {
        return;
    } else {
        // 此时需要判断登录
        if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
            [AppDelegate presentLoginNav:self];
            return;
        }
        CirclePostViewController *vc = [[CirclePostViewController alloc] init];
        vc.isReplayComment = YES;
        vc.commentCircleInfo = _detailInfo;
        vc.replayCommentInfo = pass;
        [self.navigationController pushViewController:vc animated:YES];
        // 跳转到发布页面
//        replayUserId = [NSString stringWithFormat:@"%@",[pass objectForKey:@"user_id"]];
//        [_commentView.inputTextView becomeFirstResponder];
//        _commentView.placeHoderLab.text = [NSString stringWithFormat:@"回复@%@",[pass objectForKey:@"nick_name"]];
        return;
    }
}

- (void)getCommentReplayList {
    page = 1;
    if (SWNOTEmptyStr(_circle_id)) {
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:@(page) forKey:@"page"];
        [param setObject:@"10" forKey:@"count"];
        [param setObject:_circle_id forKey:@"circle_id"];
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path circleDetailInfoNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    _detailInfo = [NSDictionary dictionaryWithDictionary:[[responseObject objectForKey:@"data"] objectForKey:@"detail"]];
                    [_dataSource removeAllObjects];
                    [_dataSource addObjectsFromArray:[[[responseObject objectForKey:@"data"] objectForKey:@"comment"] objectForKey:@"data"]];
                    _commentInfo = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                    if (_dataSource.count<10) {
                        _tableView.mj_footer.hidden = YES;
                    } else {
                        _tableView.mj_footer.hidden = NO;
                    }
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

- (void)getMoreList {
    page = page + 1;
    NSMutableDictionary *pass = [NSMutableDictionary new];
    [pass setObject:@(page) forKey:@"page"];
    [pass setObject:@"10" forKey:@"count"];
    [pass setObject:_circle_id forKey:@"circle_id"];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path circleDetailInfoNet] WithAuthorization:nil paramDic:pass finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                _detailInfo = [NSDictionary dictionaryWithDictionary:[[responseObject objectForKey:@"data"] objectForKey:@"detail"]];
                _commentInfo = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                NSArray *passArray = [NSArray arrayWithArray:[[[responseObject objectForKey:@"data"] objectForKey:@"comment"] objectForKey:@"data"]];
                [_dataSource addObjectsFromArray:passArray];
                if (pass.count<10) {
                    _tableView.mj_footer.hidden = YES;
                } else {
                    _tableView.mj_footer.hidden = NO;
                }
            }
        }
        [_tableView reloadData];
    } enError:^(NSError * _Nonnull error) {
        page--;
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)showCirclePic:(NSDictionary *)dict imagetag:(NSInteger)tag toView:(nonnull UIImageView *)toImageView {
    currentShowPicImageView = toImageView;
    [_currentShowPicArray removeAllObjects];
    [_currentShowPicArray addObjectsFromArray:dict[@"attach_url"]];
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
    return photo;
}

// MARK: - 点赞代理(评论点赞)
- (void)zanComment:(CircleDetailCommentCell *)cell {
    // 此时需要判断登录
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    // 判断是点赞还是取消点赞  然后再判断是展示我的还是展示所有的
    if (!SWNOTEmptyDictionary(cell.userCommentInfo)) {
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary new];
    BOOL liked = [[NSString stringWithFormat:@"%@",cell.userCommentInfo[@"is_like"]] boolValue];
    if (liked) {
        // 取消点赞
        [param setObject:@"0" forKey:@"status"];
    } else {
        // 点赞
        [param setObject:@"1" forKey:@"status"];
    }
    // 圈子评论回复
    [param setObject:@"2" forKey:@"type"];
    [param setObject:[NSString stringWithFormat:@"%@",cell.userCommentInfo[@"id"]] forKey:@"obj_id"];
    [Net_API requestPOSTWithURLStr:[Net_Path circleLikeNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            [self showHudInView:self.view showHint:responseObject[@"msg"]];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                // 替换_dataSource 和 _commentInfo
                
                NSIndexPath *cellpath = [self.tableView indexPathForCell:cell];
                
                NSMutableDictionary *pass = [NSMutableDictionary dictionaryWithDictionary:_dataSource[cellpath.row]];
                [pass setObject:liked ? @"0" : @"1" forKey:@"is_like"];
                NSString *likeNum = [NSString stringWithFormat:@"%@",pass[@"like_num"]];
                [pass setObject:liked ? @([likeNum integerValue] - 1) : @([likeNum integerValue] + 1) forKey:@"like_num"];
                [_dataSource replaceObjectAtIndex:cellpath.row withObject:pass];
                
                [_tableView reloadRowAtIndexPath:cellpath withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        [self showHudInView:self.view showHint:@"操作失败,请稍后再试"];
    }];
}

// MARK: - 删除自己评论或者回复
- (void)deleteComment:(CircleDetailCommentCell *)cell {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确认删除该条评论？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteCircleComment:[NSString stringWithFormat:@"%@",cell.userCommentInfo[@"id"]]];
        }];
    [commentAction setValue:EdlineV5_Color.themeColor forKey:@"_titleTextColor"];
    [alertController addAction:commentAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
    [cancelAction setValue:EdlineV5_Color.textFirstColor forKey:@"_titleTextColor"];
    [alertController addAction:cancelAction];
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertController animated:YES completion:nil];
}

// MARK: - 点赞按钮点击事件(顶部圈子详情点赞)
- (void)likeCircleClick:(CircleListCell *)cell {
    // 此时需要判断登录
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    BOOL liked = [[NSString stringWithFormat:@"%@",cell.userCommentInfo[@"is_like"]] boolValue];
    NSString *circleId = [NSString stringWithFormat:@"%@",cell.userCommentInfo[@"id"]];
    [Net_API requestPOSTWithURLStr:[Net_Path circleLikeNet] WithAuthorization:nil paramDic:@{@"type":@"1",@"obj_id":circleId,@"status":(liked ? @"0" : @"1")} finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            [self showHudInView:self.view showHint:responseObject[@"msg"]];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                // 替换_detailInfo 和 _commentInfo
                
                NSIndexPath *cellpath = [self.tableView indexPathForCell:cell];
                
                NSMutableDictionary *pass = [NSMutableDictionary dictionaryWithDictionary:_detailInfo];
                [pass setObject:liked ? @"0" : @"1" forKey:@"is_like"];
                NSString *likeNum = [NSString stringWithFormat:@"%@",pass[@"like_num"]];
                [pass setObject:liked ? @([likeNum integerValue] - 1) : @([likeNum integerValue] + 1) forKey:@"like_num"];
                _detailInfo = [NSDictionary dictionaryWithDictionary:pass];
                
                NSMutableDictionary *passComment = [NSMutableDictionary dictionaryWithDictionary:_commentInfo];
                [passComment setObject:[NSDictionary dictionaryWithDictionary:_detailInfo] forKey:@"detail"];
                _commentInfo = [NSDictionary dictionaryWithDictionary:passComment];
                
                [_tableView reloadRowAtIndexPath:cellpath withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        [self showHudInView:self.view showHint:@"操作失败,请稍后再试"];
    }];
}

// MARK: - 转发
- (void)shareCircleClick:(CircleListCell *)cell {
    // 此时需要判断登录
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    CirclePostViewController *vc = [[CirclePostViewController alloc] init];
    vc.isForward = YES;
    vc.forwardInfo = cell.userCommentInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

//MARK: - 删除自己的圈子详情
- (void)deleteCircleClick:(CircleListCell *)cell {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确认删除该条动态？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteCircle:[NSString stringWithFormat:@"%@",cell.userCommentInfo[@"id"]]];
        }];
    [commentAction setValue:EdlineV5_Color.themeColor forKey:@"_titleTextColor"];
    [alertController addAction:commentAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
    [cancelAction setValue:EdlineV5_Color.textFirstColor forKey:@"_titleTextColor"];
    [alertController addAction:cancelAction];
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertController animated:YES completion:nil];
}

// MARK: - 底部评论按钮点击事件
- (void)commentCircleButtonClick:(UIButton *)sender {
    // 此时需要判断登录
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    CirclePostViewController *vc = [[CirclePostViewController alloc] init];
    vc.isComment = YES;
    vc.commentCircleInfo = _detailInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - 删除圈子
- (void)deleteCircle:(NSString *)circleId {
    if (SWNOTEmptyStr(circleId)) {
        [Net_API requestDeleteWithURLStr:[Net_Path circlePost] paramDic:@{@"id":circleId} Api_key:nil finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                [self showHudInView:self.view showHint:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMyCircleData" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteActionReloadData" object:nil];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });

                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

// MARK: - 删除圈子评论或者回复
- (void)deleteCircleComment:(NSString *)circleCommentId {
    if (SWNOTEmptyStr(circleCommentId)) {
        [Net_API requestDeleteWithURLStr:[Net_Path circleCommentOrReplay] paramDic:@{@"id":circleCommentId} Api_key:nil finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                [self showHudInView:self.view showHint:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    // 请求接口刷新数据 就不手动处理数据源了
                    [self.tableView.mj_header beginRefreshing];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

// MARK: - 跳转到用户主页(区分自己和他人)
- (void)goToUserHomePage:(CircleListCell *)cell {
    NSString *user_id = [NSString stringWithFormat:@"%@",cell.userCommentInfo[@"user_id"]];
    if (SWNOTEmptyStr(user_id)) {
        if ([user_id isEqualToString:[V5_UserModel uid]]) {
            // 自己
            MyCirclePageVC *vc = [[MyCirclePageVC alloc] init];
            vc.teacherId = user_id;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            // 他人
            UserHomePageViewController *vc = [[UserHomePageViewController alloc] init];
            vc.teacherId = user_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

// MARK: - 关注按钮点击事件
- (void)followUser:(CircleListCell *)cell {
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    NSString *userId = [NSString stringWithFormat:@"%@",[cell.userCommentInfo objectForKey:@"user_id"]];
    if ([[cell.userCommentInfo objectForKey:@"followed"] boolValue]) {
        [Net_API requestDeleteWithURLStr:[Net_Path userFollowNet] paramDic:@{@"user_id":userId} Api_key:nil finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                [self showHudInView:self.view showHint:responseObject[@"msg"]];
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    // 更新数据源
                    NSIndexPath *cellpath = [self.tableView indexPathForCell:cell];
                    
                    NSMutableDictionary *pass = [NSMutableDictionary dictionaryWithDictionary:_detailInfo];
                    [pass setObject:@"0" forKey:@"followed"];
                    _detailInfo = [NSDictionary dictionaryWithDictionary:pass];
                    
                    NSMutableDictionary *passComment = [NSMutableDictionary dictionaryWithDictionary:_commentInfo];
                    [passComment setObject:[NSDictionary dictionaryWithDictionary:_detailInfo] forKey:@"detail"];
                    _commentInfo = [NSDictionary dictionaryWithDictionary:passComment];
                    
                    [_tableView reloadRowAtIndexPath:cellpath withRowAnimation:UITableViewRowAnimationNone];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"followActionReloadData" object:nil];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    } else {
        [Net_API requestPOSTWithURLStr:[Net_Path userFollowNet] WithAuthorization:nil paramDic:@{@"user_id":userId} finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                [self showHudInView:self.view showHint:responseObject[@"msg"]];
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    // 更新数据源
                    NSIndexPath *cellpath = [self.tableView indexPathForCell:cell];
                    
                    NSMutableDictionary *pass = [NSMutableDictionary dictionaryWithDictionary:_detailInfo];
                    [pass setObject:@"1" forKey:@"followed"];
                    _detailInfo = [NSDictionary dictionaryWithDictionary:pass];
                    
                    NSMutableDictionary *passComment = [NSMutableDictionary dictionaryWithDictionary:_commentInfo];
                    [passComment setObject:[NSDictionary dictionaryWithDictionary:_detailInfo] forKey:@"detail"];
                    _commentInfo = [NSDictionary dictionaryWithDictionary:passComment];
                    
                    [_tableView reloadRowAtIndexPath:cellpath withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

// MARK: - 转发动态试图点击跳转到原动态详情页
- (void)jumpToForwarOriginCircleDetailVC:(CircleListCell *)cell {
    CircleDetailViewController *vc = [[CircleDetailViewController alloc] init];
    vc.circle_id = [NSString stringWithFormat:@"%@",[cell.userCommentInfo objectForKey:@"orignal_id"]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
