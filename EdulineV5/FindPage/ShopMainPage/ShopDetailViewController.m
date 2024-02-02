//
//  ShopDetailViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/11/11.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "SDCycleScrollView.h"
#import "ShopContentView.h"
#import "ShopIntroduceVC.h"

#import "AppDelegate.h"
#import "V5_UserModel.h"

#import "ShopOrderSureVC.h"

@interface ShopDetailViewController ()<SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> {
    // 新增内容
    CGFloat sectionHeight;
    CGFloat introduceHeight;
    BOOL loadedIntroducePage;
}

@property (strong, nonatomic) LBHTableView *tableView;
@property (nonatomic, retain) UIScrollView *mainScroll;
@property (nonatomic, strong) UIView *bg;
@property (strong, nonatomic) UIView *headerView;

@property (nonatomic, retain) UIScrollView *bannerViewScroll;
@property (nonatomic, strong) UILabel *bannerlabel;
// 轮播图和分类
@property (strong, nonatomic) NSMutableArray *bannerImageArray;
@property (strong, nonatomic) NSMutableArray *bannerImageSourceArray;

@property (strong, nonatomic) ShopContentView *contentView;

@property (strong, nonatomic) ShopIntroduceVC *introduceVC;

// 底部视图
@property (strong, nonatomic) UIView *shopDownView;
@property (strong, nonatomic) UIButton *submitButton;// 立即

// 顶部视图
@property (strong, nonatomic) UIButton *navBackButton;
@property (strong, nonatomic) UIButton *navShareButton;

@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopIntroducePageHeight:) name:@"getShopIntroducePageHeight" object:nil];
    
    /// 新增内容
    self.canScroll = YES;
    self.canScrollAfterVideoPlay = YES;
    
    _lineTL.hidden = YES;
    _rightButton.hidden = YES;
    [_rightButton setImage:Image(@"share_white_icon") forState:0];
    [_leftButton setImage:Image(@"nav_back_white") forState:0];
    _titleImage.alpha = 0;
    
    _bannerImageArray = [NSMutableArray new];
    _bannerImageSourceArray = [NSMutableArray new];
//    [_bannerImageArray addObjectsFromArray:@[@"tempShop",@"tempShop",@"tempShop",@"tempShop"]];
    
    [self makeHeaderView];
    [self makeBannerView];
    
//    [self setBannerImageUI];
    
    _navBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _navBackButton.frame = CGRectMake(0, 22+MACRO_UI_STATUSBAR_ADD_HEIGHT, 54, 44);
    [_navBackButton setImage:Image(@"course_back_icon") forState:0];
    [_navBackButton addTarget:self action:@selector(navLeftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_navBackButton];
    
    _navShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _navShareButton.frame = CGRectMake(MainScreenWidth-52, 22+MACRO_UI_STATUSBAR_ADD_HEIGHT, 53, 44);
    [_navShareButton setImage:Image(@"course_share_icon") forState:0];
    [_navShareButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_headerView addSubview:_navShareButton];
    
    [self makeContentView];
    [self makeDownView];
    sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - 50 - MACRO_UI_UPHEIGHT;
    [self makeTableView];
    _tableView.tableHeaderView = _headerView;
    [_tableView reloadData];
    
    [self getShopDetailInfo];
    
    // Do any additional setup after loading the view.
}

// MARK: - tableview 的 headerview
- (void)makeHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenWidth + 90 + 4)];
    _headerView.backgroundColor = EdlineV5_Color.backColor;
}

// MARK: - contentView
- (void)makeContentView {
    _contentView = [[ShopContentView alloc] initWithFrame:CGRectMake(0, MainScreenWidth, MainScreenWidth, 90)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:_contentView];
}

// MARK: - tableview
- (void)makeTableView {
    _tableView = [[LBHTableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_SAFEAREA - 50)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    _tableView.tableHeaderView = _headerView;
    [self.view addSubview:_tableView];
}

- (void)makeBannerView {
    if (!_bannerViewScroll) {
        _bannerViewScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenWidth)];
        _bannerViewScroll.backgroundColor = [UIColor whiteColor];
        _bannerViewScroll.pagingEnabled = YES;
        _bannerViewScroll.showsHorizontalScrollIndicator = NO;
        _bannerViewScroll.showsVerticalScrollIndicator = NO;
        _bannerViewScroll.bounces = NO;
        _bannerViewScroll.delegate = self;
    }
    _bannerViewScroll.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenWidth);
    [_bannerViewScroll removeAllSubviews];
    [_headerView addSubview:_bannerViewScroll];
    
    
    _bannerlabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 44, MainScreenWidth - 15 - 23, 44, 23)];
    _bannerlabel.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3000].CGColor;
    _bannerlabel.layer.cornerRadius = 11.5;
    _bannerlabel.font = SYSTEMFONT(14);
    _bannerlabel.textColor = [UIColor whiteColor];
    _bannerlabel.hidden = YES;
    _bannerlabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:_bannerlabel];
}

// MARK: - 底部视图(咨询、加入购物车、加入学习)
- (void)makeDownView {
    _shopDownView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT, MainScreenWidth, MACRO_UI_TABBAR_HEIGHT)];
    [self.view addSubview:_shopDownView];
    
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 6.5, MainScreenWidth - 30, 36)];
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 18;
    [_submitButton setTitle:@"立即兑换" forState:0];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:0];
    _submitButton.titleLabel.font = SYSTEMFONT(16);
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = _submitButton.bounds;
    // 渐变色颜色数组,可多个
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[HEXCOLOR(0xFF3B2F) CGColor], (id)[HEXCOLOR(0xFF8A52) CGColor], nil];
    // 渐变的开始点 (不同的起始点可以实现不同位置的渐变,如图)
    gradientLayer.startPoint = CGPointMake(0, 0.5f); //(0, 0)
    // 渐变的结束点
    gradientLayer.endPoint = CGPointMake(1, 0.5f); //(1, 1)
    [_submitButton.layer insertSublayer:gradientLayer atIndex:0];
    [_shopDownView addSubview:_submitButton];
    [_submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifireAC =@"shopDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifireAC];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifireAC];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return sectionHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    __weak ShopDetailViewController *weakself = self;
    if (weakself.bg == nil) {
        weakself.bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, sectionHeight)];
        weakself.bg.backgroundColor = [UIColor whiteColor];
    } else {
        weakself.bg.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight);
    }
    if (sectionHeight>1) {
        if (self.mainScroll == nil) {
            self.mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, MainScreenWidth, sectionHeight)];
            self.mainScroll.contentSize = CGSizeMake(0, 0);
            self.mainScroll.pagingEnabled = YES;
            self.mainScroll.showsHorizontalScrollIndicator = NO;
            self.mainScroll.showsVerticalScrollIndicator = NO;
            self.mainScroll.bounces = NO;
            self.mainScroll.delegate = self;
            [_bg addSubview:self.mainScroll];
        } else {
            self.mainScroll.frame = CGRectMake(0,0, MainScreenWidth, sectionHeight);
        }

        if (weakself.introduceVC == nil) {
            weakself.introduceVC = [[ShopIntroduceVC alloc] init];
            weakself.introduceVC.courseId = weakself.shopId;
            weakself.introduceVC.dataSource = weakself.dataSource;
            weakself.introduceVC.tabelHeight = sectionHeight;
            weakself.introduceVC.cellTabelCanScroll = !weakself.canScrollAfterVideoPlay;
            weakself.introduceVC.vc = weakself;
            weakself.introduceVC.view.frame = CGRectMake(0,0, MainScreenWidth, sectionHeight);
            [weakself.mainScroll addSubview:weakself.introduceVC.view];
            [weakself addChildViewController:weakself.introduceVC];
        } else {
            if (!loadedIntroducePage) {
                weakself.introduceVC.dataSource = weakself.dataSource;
                loadedIntroducePage = YES;
            }
            weakself.introduceVC.tabelHeight = sectionHeight;
            weakself.introduceVC.cellTabelCanScroll = !weakself.canScrollAfterVideoPlay;
            weakself.introduceVC.view.frame = CGRectMake(0,0, MainScreenWidth, sectionHeight);
            [weakself.introduceVC changeMainScrollViewHeight:sectionHeight];
        }
    }
    return weakself.bg;
}

// MARK: - 滚动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGFloat bottomCellOffset = self.headerView.height - MACRO_UI_UPHEIGHT;
        if (scrollView.contentOffset.y > bottomCellOffset - 0.5) {
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            if (self.canScroll) {
                self.canScroll = NO;
                for (UIViewController *vc in self.childViewControllers) {
                    if ([vc isKindOfClass:[ShopIntroduceVC class]]) {
                        ShopIntroduceVC *vccomment = (ShopIntroduceVC *)vc;
                        vccomment.cellTabelCanScroll = YES;
                    }
                }
            }
        }else{
            if (!self.canScroll) {//子视图没到顶部
                if (self.canScrollAfterVideoPlay) {
                    scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
                } else {
                    scrollView.contentOffset = CGPointMake(0, 0);
                }
            }
        }
    } else if (scrollView == self.bannerViewScroll) {
        NSInteger currentTag = scrollView.contentOffset.x/MainScreenWidth;
        _bannerlabel.text = [NSString stringWithFormat:@"%@/%@",@(currentTag + 1),@(_bannerImageArray.count)];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// banner赋值
- (void)setBannerImageUI {
    if (SWNOTEmptyArr(_bannerImageArray)) {
        [_bannerViewScroll removeAllSubviews];
        for (int i = 0; i < _bannerImageArray.count; i++) {
            UIImageView *bannerImg = [[UIImageView alloc] initWithFrame:CGRectMake(i * _bannerViewScroll.width, 0, _bannerViewScroll.width, _bannerViewScroll.height)];
            [bannerImg sd_setImageWithURL:EdulineUrlString(_bannerImageArray[i][@"fileurl"]) placeholderImage:DefaultImage];
//            bannerImg.image = Image(_bannerImageArray[i]);
            bannerImg.contentMode = UIViewContentModeScaleAspectFill;
            [_bannerViewScroll addSubview:bannerImg];
        }
    }
    _bannerViewScroll.contentSize = CGSizeMake(MainScreenWidth*_bannerImageArray.count, 0);
    if (_bannerImageArray.count > 1) {
        _bannerlabel.text = [NSString stringWithFormat:@"1/%@",@(_bannerImageArray.count)];
        _bannerlabel.hidden = NO;
    } else {
        _bannerlabel.hidden = YES;
    }
}

// MARK: - 返回按钮点击事件
- (void)navLeftButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonClick:(id)sender {
    
}

- (void)submitButtonClick {
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    ShopOrderSureVC *vc = [[ShopOrderSureVC alloc] init];
    vc.shopID = _shopId;
    [self.navigationController pushViewController:vc animated:YES];
}

/** 获取商品详情 */
- (void)getShopDetailInfo {
    if (SWNOTEmptyStr(_shopId)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path shopDetailInfo:_shopId] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    _dataSource = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
                    
                    [_bannerImageArray removeAllObjects];
                    [_bannerImageArray addObjectsFromArray:_dataSource[@"swiper"]];
                    [self setBannerImageUI];
                    
                    [_contentView setShopContentInfo:_dataSource];
                    [_contentView setHeight:_contentView.height];
                    
                    [_headerView setHeight:MainScreenWidth + _contentView.height + 4];
                    
                    _tableView.tableHeaderView = _headerView;
                    [_tableView reloadData];
                } else {
                    [self showHudInView:self.view showHint:responseObject[@"msg"]];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            [self showHudInView:self.view showHint:@"网络飞走了"];
        }];
    }
}

- (void)getShopIntroducePageHeight:(NSNotification *)notice {
    if (SWNOTEmptyDictionary(notice.userInfo)) {
        sectionHeight = [[NSString stringWithFormat:@"%@",notice.userInfo[@"introHeight"]] floatValue];
        sectionHeight = MIN(MainScreenHeight - MACRO_UI_SAFEAREA - 50 - MACRO_UI_UPHEIGHT, sectionHeight);
        [self.tableView reloadData];
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
