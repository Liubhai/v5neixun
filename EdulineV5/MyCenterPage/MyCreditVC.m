//
//  MyCreditVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/3/29.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "MyCreditVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "ScoreNewCell.h"
#import "CourseSearchListVC.h"

@interface MyCreditVC ()<UITableViewDelegate, UITableViewDataSource> {
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

@property (strong, nonatomic) UIView *tableBackView;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MyCreditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = EdlineV5_Color.backColor;
    
    _dataSource = [NSMutableArray new];
    _scoreInfo = [NSDictionary new];
    page = 1;
    
    _titleImage.hidden = YES;
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100)];
    [self.view addSubview:_headerView];
    
    _topBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 155 + MACRO_UI_STATUSBAR_ADD_HEIGHT)];
    _topBackImageView.image = Image(@"integral_top_bg_neixun");
    [_headerView addSubview:_topBackImageView];
    
    _leftPopButton = [[UIButton alloc] initWithFrame:_leftButton.frame];
    [_leftPopButton setImage:Image(@"nav_back_white") forState:0];
    [_leftPopButton addTarget:self action:@selector(leftPopButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_leftPopButton];
    
    _titleShowLabel = [[UILabel alloc] initWithFrame:_titleLabel.frame];
    _titleShowLabel.font = _titleLabel.font;
    _titleShowLabel.textColor = [UIColor whiteColor];
    _titleShowLabel.text = @"我的学分";
    _titleShowLabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:_titleShowLabel];
    
    _scoreCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 75 + MACRO_UI_STATUSBAR_ADD_HEIGHT, 100, 47)];
    _scoreCountLabel.font = SYSTEMFONT(40);
    _scoreCountLabel.textColor = [UIColor whiteColor];
    [_headerView addSubview:_scoreCountLabel];
    
    _scoreBigIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_scoreCountLabel.right + 4, 0, 35, 35)];
    _scoreBigIcon.image = Image(@"credit_icon");
    _scoreBigIcon.centerY = _scoreCountLabel.centerY;
    [_headerView addSubview:_scoreBigIcon];
    
    _signButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 115 - 8, 0, 115, 55)];
    _signButton.centerY = _scoreCountLabel.centerY;
    [_signButton setImage:Image(@"signin_botton_neixun") forState:0];
    [_signButton addTarget:self action:@selector(signButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_signButton];
    
    UIView *whiteLayer = [[UIView alloc] initWithFrame:CGRectMake(0, _topBackImageView.height - 15, MainScreenWidth, 15)];
    whiteLayer.backgroundColor = [UIColor whiteColor];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:whiteLayer.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = whiteLayer.bounds;
    maskLayer.path = maskPath.CGPath;
    whiteLayer.layer.mask = maskLayer;
    [_headerView addSubview:whiteLayer];
    
    _tableBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _topBackImageView.bottom, MainScreenWidth, 43)];
    [_headerView addSubview:_tableBackView];
    [_headerView setHeight:_tableBackView.bottom];
    
    UILabel *scoreDetailTitle = [[UILabel alloc] initWithFrame:CGRectMake(22, 12, 150, 22)];
    scoreDetailTitle.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
    scoreDetailTitle.textColor = EdlineV5_Color.textFirstColor;
    scoreDetailTitle.text = @"学分明细";
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
    [cell setScoreInfo:_dataSource[indexPath.row] isCredit:YES];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
}

- (void)getFirstData {
    page = 1;
    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path studyScoreNet] WithAuthorization:nil paramDic:@{@"page":@(page),@"count":@"10"} finish:^(id  _Nonnull responseObject) {
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
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path studyScoreNet] WithAuthorization:nil paramDic:@{@"page":@(page),@"count":@"10"} finish:^(id  _Nonnull responseObject) {
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
        _scoreCountLabel.text = [NSString stringWithFormat:@"%@",_scoreInfo[@"score"]];
        CGFloat scoreWith = [_scoreCountLabel.text sizeWithFont:_scoreCountLabel.font].width + 4;
        [_scoreCountLabel setWidth:scoreWith];
        [_scoreBigIcon setLeft:_scoreCountLabel.right + 2];// 原本宽度+4这里就少加2 看上去更真实
    }
}

- (void)signButtonClick {
    CourseSearchListVC *vc = [[CourseSearchListVC alloc] init];
    vc.isSearch = YES;
    vc.hiddenNavDisappear = YES;
    vc.notHiddenNav = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)leftPopButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
