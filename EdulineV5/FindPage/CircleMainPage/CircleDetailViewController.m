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

@interface CircleDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CircleListCellDelegate,CircleDetailCommentCellDelegate> {
    NSInteger page;
    NSString *replayUserId;
}

@property (strong, nonatomic) UILabel *replayCountLabel;

@property (strong, nonatomic) UIView *commentBackView;
@property (strong, nonatomic) UILabel *commentPlaceLabel;
@property (strong, nonatomic) UIButton *commentButton;

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
    _dataSource = [NSMutableArray new];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - CommenViewHeight - MACRO_UI_SAFEAREA)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    _commentPlaceLabel.text = @" 评论";
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
        
        _replayCountLabel.text = [NSString stringWithFormat:@"共%@条回复",SWNOTEmptyDictionary(_commentInfo) ? [[_commentInfo objectForKey:@"comment"] objectForKey:@"total"] : @"0"];
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
        if ([[NSString stringWithFormat:@"%@",[[pass objectForKey:@"user"] objectForKey:@"id"]] isEqualToString:[V5_UserModel uid]]) {
            isMine = YES;
        }
    }
    if (isMine) {
        return;
    } else {
        // 跳转到发布页面
//        replayUserId = [NSString stringWithFormat:@"%@",[pass objectForKey:@"user_id"]];
//        [_commentView.inputTextView becomeFirstResponder];
//        _commentView.placeHoderLab.text = [NSString stringWithFormat:@"回复@%@",[pass objectForKey:@"nick_name"]];
        return;
    }
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

// MARK: - 点赞代理
- (void)zanComment:(CircleDetailCommentCell *)cell {
    // 判断是点赞还是取消点赞  然后再判断是展示我的还是展示所有的
    if (!SWNOTEmptyDictionary(cell.userCommentInfo)) {
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary new];
    if ([[cell.userCommentInfo objectForKey:@"is_like"] boolValue]) {
        // 取消点赞
        [param setObject:@"0" forKey:@"status"];
    } else {
        // 点赞
        [param setObject:@"1" forKey:@"status"];
    }
}

// MARK: - 底部评论按钮点击事件
- (void)commentCircleButtonClick:(UIButton *)sender {
    
}

@end
