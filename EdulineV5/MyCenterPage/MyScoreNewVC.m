//
//  MyScoreNewVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/8/24.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "MyScoreNewVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "ScoreNewCell.h"
#import "CourseSearchListVC.h"
#import "ShopMainViewController.h"

@interface MyScoreNewVC ()<UITableViewDelegate, UITableViewDataSource> {
    NSInteger page;
}

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSDictionary *scoreInfo;

@property (strong, nonatomic) UIView *headerView;

@property (strong, nonatomic) UIImageView *topBackImageView;
@property (strong, nonatomic) UIButton *leftPopButton;
@property (strong, nonatomic) UILabel *titleShowLabel;
@property (strong, nonatomic) UILabel *scoreCountLabel;
@property (strong, nonatomic) UIImageView *scoreBigIcon;
@property (strong, nonatomic) UIButton *signButton;

@property (strong, nonatomic) UIImageView *methodBackImageView;
@property (strong, nonatomic) UILabel *methodTipLabel;
@property (strong, nonatomic) UIView *methodWhiteBackView;

@property (strong, nonatomic) UIView *tableBackView;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIView *commentGuideView;
@property (strong, nonatomic) UIView *shareGuideView;

@end

@implementation MyScoreNewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = EdlineV5_Color.backColor;
    
    _dataSource = [NSMutableArray new];
    _scoreInfo = [NSDictionary new];
    page = 1;
    
    _titleImage.hidden = YES;
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100)];
    [self.view addSubview:_headerView];
    
    _topBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 230 + MACRO_UI_STATUSBAR_ADD_HEIGHT)];
    _topBackImageView.image = Image(@"integral_top_bg");
    [_headerView addSubview:_topBackImageView];
    
    _leftPopButton = [[UIButton alloc] initWithFrame:_leftButton.frame];
    [_leftPopButton setImage:Image(@"nav_back_white") forState:0];
    [_leftPopButton addTarget:self action:@selector(leftPopButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_leftPopButton];
    
    _titleShowLabel = [[UILabel alloc] initWithFrame:_titleLabel.frame];
    _titleShowLabel.font = _titleLabel.font;
    _titleShowLabel.textColor = [UIColor whiteColor];
    _titleShowLabel.text = @"我的积分";
    _titleShowLabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:_titleShowLabel];
    
    _scoreCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 75 + MACRO_UI_STATUSBAR_ADD_HEIGHT, 100, 47)];
    _scoreCountLabel.font = SYSTEMFONT(40);
    _scoreCountLabel.textColor = [UIColor whiteColor];
    [_headerView addSubview:_scoreCountLabel];
    
    _scoreBigIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_scoreCountLabel.right + 4, 0, 35, 35)];
    _scoreBigIcon.image = Image(@"integral_big_icon");
    _scoreBigIcon.centerY = _scoreCountLabel.centerY;
    [_headerView addSubview:_scoreBigIcon];
    
    _signButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 115 - 8, 0, 115, 55)];
    _signButton.centerY = _scoreCountLabel.centerY;
    [_signButton addTarget:self action:@selector(signButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_signButton];
    
    _methodBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, _signButton.bottom + 24, MainScreenWidth - 30, 280 + (36 + 30))];
    _methodBackImageView.image = Image(@"integral_center_bg");
    _methodBackImageView.userInteractionEnabled = YES;
    [_headerView addSubview:_methodBackImageView];
    
    _methodTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 12, 150, 22)];
    _methodTipLabel.font = SYSTEMFONT(16);
    _methodTipLabel.textColor = HEXCOLOR(0x755211);
    _methodTipLabel.text = @"积分获取";
    [_methodBackImageView addSubview:_methodTipLabel];
    
    _methodWhiteBackView = [[UIView alloc] initWithFrame:CGRectMake(7.5, 46, _methodBackImageView.width - 15, 220 + (36 + 30))];
    _methodWhiteBackView.backgroundColor = [UIColor whiteColor];
    _methodWhiteBackView.layer.masksToBounds = YES;
    _methodWhiteBackView.layer.cornerRadius = 10;
    [_methodBackImageView addSubview:_methodWhiteBackView];
    
    NSArray *methodIcon1 = @[@"integral_buy_icon",@"integral_comment_icon",@"integral_share_icon",@"integral_buy_icon"];
    NSArray *methodTitle = @[@"购买课程",@"评论课程",@"分享课程",@"兑换商品"];
    NSArray *methodIcon2 = @[@"buy_button_neixun",@"comment_button_score",@"share_button_score",@"share_button"];
    
    for (int i = 0; i < methodIcon1.count; i++) {
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 26 + (36 + 30) * i, 36, 36)];
        icon.image = Image(methodIcon1[i]);
        [_methodWhiteBackView addSubview:icon];
        
        UILabel *methodLabel = [[UILabel alloc] initWithFrame:CGRectMake(icon.right + 11, 0, 100, 36)];
        methodLabel.centerY = icon.centerY;
        methodLabel.font = SYSTEMFONT(16);
        methodLabel.textColor = EdlineV5_Color.textFirstColor;
        methodLabel.text = methodTitle[i];
        [_methodWhiteBackView addSubview:methodLabel];
        
        UIButton *doButton = [[UIButton alloc] initWithFrame:CGRectMake(_methodWhiteBackView.width - 87, 0, 87, 44)];
        [doButton addTarget:self action:@selector(doButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        doButton.centerY = icon.centerY;
        [doButton setImage:Image(methodIcon2[i]) forState:0];
        doButton.tag = 66 + i;
        [_methodWhiteBackView addSubview:doButton];
    }
    
    _tableBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _methodBackImageView.bottom + 12, MainScreenWidth, 43)];//MainScreenHeight - (_methodBackImageView.bottom + 12) + 20)
//    _tableBackView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
//    _tableBackView.layer.cornerRadius = 15;
//    _tableBackView.layer.shadowColor = [UIColor colorWithRed:107/255.0 green:107/255.0 blue:107/255.0 alpha:0.05].CGColor;
//    _tableBackView.layer.shadowOffset = CGSizeMake(0,1);
//    _tableBackView.layer.shadowOpacity = 1;
//    _tableBackView.layer.shadowRadius = 8;
    [_headerView addSubview:_tableBackView];
    [_headerView setHeight:_tableBackView.bottom];
    
    UILabel *scoreDetailTitle = [[UILabel alloc] initWithFrame:CGRectMake(22, 12, 150, 22)];
    scoreDetailTitle.font = SYSTEMFONT(16);
    scoreDetailTitle.textColor = EdlineV5_Color.textFirstColor;
    scoreDetailTitle.text = @"积分明细";
    [_tableBackView addSubview:scoreDetailTitle];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 42, _tableBackView.width, 1)];
    lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_tableBackView addSubview:lineView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = _headerView;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getFirstData)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    [_tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"ScoreNewCell";
    ScoreNewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ScoreNewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setScoreInfo:_dataSource[indexPath.row] isCredit:NO];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
}

- (void)getFirstData {
    page = 1;
    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path userScoreDetailNewNet] WithAuthorization:nil paramDic:@{@"page":@(page),@"count":@"10"} finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                
                _scoreInfo = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
                
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[[[responseObject objectForKey:@"data"] objectForKey:@"flow"] objectForKey:@"data"]];
            }
        }
        if (_dataSource.count<10) {
            _tableView.mj_footer.hidden = YES;
        } else {
            _tableView.mj_footer.hidden = NO;
        }
        [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_tableView.height];
        [_tableView reloadData];
        [self setTopInfoData];
    } enError:^(NSError * _Nonnull error) {
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header endRefreshing];
        }
    }];
}

- (void)getMoreData {
    page = page + 1;
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path userScoreDetailNewNet] WithAuthorization:nil paramDic:@{@"page":@(page),@"count":@"10"} finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSArray *pass = [NSArray arrayWithArray:[[[responseObject objectForKey:@"data"] objectForKey:@"flow"] objectForKey:@"data"]];
                [_dataSource addObjectsFromArray:pass];
                if (pass.count<10) {
                    _tableView.mj_footer.hidden = YES;
                } else {
                    _tableView.mj_footer.hidden = NO;
                }
            }
        }
        [_tableView reloadData];
        [self setTopInfoData];
    } enError:^(NSError * _Nonnull error) {
        page--;
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
    }];
}

// MARK: - 赋值
- (void)setTopInfoData {
    if (SWNOTEmptyDictionary(_scoreInfo)) {
        _scoreCountLabel.text = [NSString stringWithFormat:@"%@",_scoreInfo[@"credit"]];
        if (_scoreCountLabel.text.length > 7) {
            _scoreCountLabel.font = SYSTEMFONT(30);
        }
        if (_scoreCountLabel.text.length > 10) {
            _scoreCountLabel.font = SYSTEMFONT(25);
        }
        CGFloat scoreWith = [_scoreCountLabel.text sizeWithFont:_scoreCountLabel.font].width + 4;
        [_scoreCountLabel setWidth:scoreWith];
        [_scoreBigIcon setLeft:_scoreCountLabel.right + 2];// 原本宽度+4这里就少加2 看上去更真实
        
        NSString *is_sign = [NSString stringWithFormat:@"%@",_scoreInfo[@"today_punch_in"]];
        if ([is_sign boolValue]) {
            [_signButton setImage:Image(@"signin_botton_dis") forState:0];
        } else {
            [_signButton setImage:Image(@"signin_botton") forState:0];
        }
    }
}

- (void)signButtonClick {
    NSString *is_sign = [NSString stringWithFormat:@"%@",_scoreInfo[@"today_punch_in"]];
    if ([is_sign boolValue]) {
        return;
    } else {
        // 请求签到接口
        [self signNet];
    }
}

- (void)doButtonClick:(UIButton *)sender {
    if (sender.tag == 67) {
        [self makeCommentGuideViewUI];
    } else if (sender.tag == 68) {
        [self makeShareGuideViewUI];
    } else if (sender.tag == 69) {
        ShopMainViewController *vc = [[ShopMainViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        CourseSearchListVC *vc = [[CourseSearchListVC alloc] init];
        vc.isSearch = YES;
        vc.hiddenNavDisappear = YES;
        vc.notHiddenNav = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)leftPopButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

// MARK: - 请求签到接口
- (void)signNet {
    [Net_API requestPOSTWithURLStr:[Net_Path userScoreSign] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            [self showHudInView:self.view showHint:responseObject[@"msg"]];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_tableView.mj_header beginRefreshing];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        [self showHudInView:self.view showHint:@"签到失败"];
    }];
}

- (void)makeCommentGuideViewUI {
    if (!_commentGuideView) {
        _commentGuideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
        _commentGuideView.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3].CGColor;
        [self.view addSubview:_commentGuideView];
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(52.5,152,270,364);
        view.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        view.layer.cornerRadius = 7;
        [_commentGuideView addSubview:view];
        view.center = CGPointMake(MainScreenWidth / 2.0, MainScreenHeight / 2.0);
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, view.width - 30, 40)];
        tipLabel.font = SYSTEMFONT(13);
        tipLabel.textColor = EdlineV5_Color.textFirstColor;
        tipLabel.numberOfLines = 0;
        tipLabel.text = @"第一步：进入课程详情页，切换至“点评”\n第二步：点击“点评”按钮，进入评论页";
        [view addSubview:tipLabel];
        
        UIImageView *guideView = [[UIImageView alloc] initWithFrame:CGRectMake(15, tipLabel.bottom + 10, view.width - 30, 218)];
        guideView.image = Image(@"popup_comment_img");
        [view addSubview:guideView];
        
        UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(0, guideView.bottom + 20, 135, 36)];
        sureButton.layer.masksToBounds = YES;
        sureButton.layer.cornerRadius = 18;
        sureButton.backgroundColor = HEXCOLOR(0xFF8A52);
        [sureButton setTitle:@"知道了" forState:0];
        [sureButton setTitleColor:[UIColor whiteColor] forState:0];
        sureButton.titleLabel.font = SYSTEMFONT(18);
        sureButton.centerX = view.width / 2.0;
        sureButton.tag = 88;
        [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:sureButton];
    }
    _commentGuideView.hidden = NO;
}

- (void)makeShareGuideViewUI {
    if (!_shareGuideView) {
        _shareGuideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
        _shareGuideView.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3].CGColor;
        [self.view addSubview:_shareGuideView];
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(52.5,152,270,569);
        view.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        view.layer.cornerRadius = 7;
        [_shareGuideView addSubview:view];
        view.center = CGPointMake(MainScreenWidth / 2.0, MainScreenHeight / 2.0);
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, view.width - 30, 40)];
        tipLabel.font = SYSTEMFONT(13);
        tipLabel.textColor = EdlineV5_Color.textFirstColor;
        tipLabel.numberOfLines = 0;
        tipLabel.text = @"第一步：进入课程详情页，点击右上角分享按钮进入分享页面";
        [view addSubview:tipLabel];
        
        UIImageView *guideView = [[UIImageView alloc] initWithFrame:CGRectMake(15, tipLabel.bottom + 10, view.width - 30, 184)];
        guideView.image = Image(@"popup_share_img1");
        [view addSubview:guideView];
        
        UILabel *tipLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(15, guideView.bottom + 10, view.width - 30, 25)];
        tipLabel2.font = SYSTEMFONT(13);
        tipLabel2.textColor = EdlineV5_Color.textFirstColor;
        tipLabel2.numberOfLines = 0;
        tipLabel2.text = @"第二步：选择分享方式，分享完成即可";
        [view addSubview:tipLabel2];
        
        UIImageView *guideView2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, tipLabel2.bottom + 10, view.width - 30, 194)];
        guideView2.image = Image(@"popup_share_img2");
        [view addSubview:guideView2];
        
        UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(0, guideView2.bottom + 20, 135, 36)];
        sureButton.layer.masksToBounds = YES;
        sureButton.layer.cornerRadius = 18;
        sureButton.backgroundColor = HEXCOLOR(0xFF8A52);
        [sureButton setTitle:@"知道了" forState:0];
        [sureButton setTitleColor:[UIColor whiteColor] forState:0];
        sureButton.titleLabel.font = SYSTEMFONT(18);
        sureButton.centerX = view.width / 2.0;
        sureButton.tag = 99;
        [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:sureButton];
    }
    _shareGuideView.hidden = NO;
}

// MARK: - 什么几把知道了按钮点击事件
- (void)sureButtonClick:(UIButton *)sender {
    if (sender.tag == 88) {
        _commentGuideView.hidden = YES;
    } else {
        _shareGuideView.hidden = YES;
    }
}

@end
