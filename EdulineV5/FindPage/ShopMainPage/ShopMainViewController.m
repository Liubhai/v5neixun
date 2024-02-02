//
//  ShopMainViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/8/12.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ShopMainViewController.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "ShopMainListCell.h"
#import "ShopSearchVC.h"
#import "ShopDetailViewController.h"
#import "ShopOrderSureVC.h"

#import "AppDelegate.h"
#import "V5_UserModel.h"

#import "TeacherCategoryModel.h"

@interface ShopMainViewController ()<UITextFieldDelegate, ShopMainListCellDelegate> {
    NSInteger page;
    NSString *cateId;
}

@property (strong, nonatomic) UITextField *institutionSearch;
@property (strong, nonatomic) UIImageView *shopFaceImage;
@property (strong, nonatomic) UIView *cateView;//分类视图

@property (strong, nonatomic) NSMutableArray *mainCateArray;
@property (strong, nonatomic) NSMutableArray *secondCateArray;

@property (strong, nonatomic) UIScrollView *mainCateScrollView;
@property (strong, nonatomic) UIImageView *mainCateSelectIcon;
@property (strong, nonatomic) UIScrollView *secondCateScrollView;

@end

@implementation ShopMainViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    self.view.backgroundColor = EdlineV5_Color.backColor;
    page = 1;
    cateId = @"";
    _dataSource = [NSMutableArray new];
    
    _mainCateArray = [[NSMutableArray alloc] init];
    _secondCateArray = [[NSMutableArray alloc] init];
    
    _shopFaceImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 105 + MACRO_UI_STATUSBAR_ADD_HEIGHT)];
    _shopFaceImage.clipsToBounds = YES;
    _shopFaceImage.contentMode = UIViewContentModeScaleAspectFill;
    _shopFaceImage.image = Image(@"store_banner_new");
    [self.view addSubview:_shopFaceImage];
    
    [_leftButton setImage:Image(@"nav_back_white") forState:0];
    [_leftButton setLeft:-6];
    
    [self makeTopSearch];
    _titleImage.backgroundColor = [UIColor clearColor];
    _lineTL.hidden = YES;
    [self.view bringSubviewToFront:_titleImage];
    
    [self makeMainCateScrollView];
    [self makeSecondCateView];
    
    [self makeCollectionView];
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getShopMainList)];
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getShopMainMoreList)];
    _collectionView.mj_footer.hidden = YES;
    [EdulineV5_Tool adapterOfIOS11With:_collectionView];
    [self getShopCateInfo];
    // Do any additional setup after loading the view.
}

// MARK: - 构建顶部搜索框
- (void)makeTopSearch {
    // 顶部搜索框和 取消按钮
    _institutionSearch = [[UITextField alloc] initWithFrame:CGRectMake(41, _titleLabel.top, MainScreenWidth - 15 - 41 , 36)];
    _institutionSearch.font = SYSTEMFONT(14);
    _institutionSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索商品名称" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:EdlineV5_Color.textSecendColor}];
    _institutionSearch.delegate = self;
    _institutionSearch.returnKeyType = UIReturnKeySearch;
    _institutionSearch.layer.cornerRadius = 18;
    _institutionSearch.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    _institutionSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    _institutionSearch.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 42, 30)];
    _institutionSearch.leftViewMode = UITextFieldViewModeAlways;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(17, 7.5, 15, 15)];
    [button setImage:Image(@"home_serch_icon_new") forState:UIControlStateNormal];
    [_institutionSearch.leftView addSubview:button];
    [_titleImage addSubview:_institutionSearch];
}

- (void)makeCateView {
    _cateView = [[UIView alloc] initWithFrame:CGRectMake(15, 167, MainScreenWidth - 30, 140)];
    _cateView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    _cateView.layer.cornerRadius = 7;
    _cateView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.08].CGColor;
    _cateView.layer.shadowOpacity = 1;// 阴影透明度，默认0
    _cateView.layer.shadowOffset = CGSizeMake(0, 1);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    _cateView.layer.shadowRadius = 12;
    [self setCateUI];
    [self.view addSubview:_cateView];
}

// MARK: - 构建大分类滚动视图
- (void)makeMainCateScrollView {
    _mainCateScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _shopFaceImage.bottom - 41, MainScreenWidth, 41)];
    _mainCateScrollView.backgroundColor = [UIColor clearColor];
    _mainCateScrollView.showsVerticalScrollIndicator = NO;
    _mainCateScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_mainCateScrollView];
}

// MARK: - 大分类在滚动视图里面的布局
- (void)makeMainCateUI {
    [_mainCateScrollView removeAllSubviews];
    if (SWNOTEmptyArr(_mainCateArray)) {
        _mainCateSelectIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30.5, 20, 7)];
        _mainCateSelectIcon.image = Image(@"store_title_icon");
        [_mainCateScrollView addSubview:_mainCateSelectIcon];
        CGFloat XX = 15;
        for (int i = 0; i<_mainCateArray.count; i++) {
            UIButton *secondCateBtn = [[UIButton alloc] initWithFrame:CGRectMake(XX, 10.5, 100, 20)];
            secondCateBtn.titleLabel.font = SYSTEMFONT(14);
            secondCateBtn.tag = 10 + i;
            secondCateBtn.backgroundColor = [UIColor clearColor];
            TeacherCategoryModel *model = (TeacherCategoryModel *)_mainCateArray[i];
            [secondCateBtn setTitle:model.title forState:0];
            [secondCateBtn setTitleColor:[UIColor whiteColor] forState:0];
            [secondCateBtn setWidth:secondCateBtn.titleLabel.text.length > 6 ? 86 : secondCateBtn.titleLabel.intrinsicContentSize.width];
            XX = secondCateBtn.right + 16;
            [secondCateBtn addTarget:self action:@selector(mainCateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_mainCateScrollView addSubview:secondCateBtn];
            if (i == 0) {
                cateId = [NSString stringWithFormat:@"%@",model.cateGoryId];
                secondCateBtn.titleLabel.font = SYSTEMFONT(16);
                [secondCateBtn setTop:8.5];
                [secondCateBtn setWidth:secondCateBtn.titleLabel.text.length > 6 ? 86 : secondCateBtn.titleLabel.intrinsicContentSize.width];
                XX = secondCateBtn.right + 16;
                _mainCateSelectIcon.centerX = secondCateBtn.centerX;
            }
        }
        _mainCateScrollView.contentSize = CGSizeMake(XX, 0);
        
        TeacherCategoryModel *model = (TeacherCategoryModel *)_mainCateArray[0];
        [_secondCateArray removeAllObjects];
        [_secondCateArray addObjectsFromArray:model.child];
        [self makeSecondCateUI];
    } else {
        [_collectionView.mj_header beginRefreshing];
    }
}

// MARK: - 大分类按钮点击事件
- (void)mainCateButtonClick:(UIButton *)sender {
    NSInteger index = sender.tag;
    [_mainCateScrollView removeAllSubviews];
    if (SWNOTEmptyArr(_mainCateArray)) {
        _mainCateSelectIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30.5, 20, 7)];
        _mainCateSelectIcon.image = Image(@"store_title_icon");
        [_mainCateScrollView addSubview:_mainCateSelectIcon];
        CGFloat XX = 15;
        for (int i = 0; i<_mainCateArray.count; i++) {
            UIButton *secondCateBtn = [[UIButton alloc] initWithFrame:CGRectMake(XX, 10.5, 100, 20)];
            secondCateBtn.titleLabel.font = SYSTEMFONT(14);
            secondCateBtn.tag = 10 + i;
            secondCateBtn.backgroundColor = [UIColor clearColor];
            TeacherCategoryModel *model = (TeacherCategoryModel *)_mainCateArray[i];
            [secondCateBtn setTitle:model.title forState:0];
            [secondCateBtn setTitleColor:[UIColor whiteColor] forState:0];
            [secondCateBtn setWidth:secondCateBtn.titleLabel.text.length > 6 ? 86 : secondCateBtn.titleLabel.intrinsicContentSize.width];
            XX = secondCateBtn.right + 16;
            [secondCateBtn addTarget:self action:@selector(mainCateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_mainCateScrollView addSubview:secondCateBtn];
            if (i == (index - 10)) {
                cateId = [NSString stringWithFormat:@"%@",model.cateGoryId];
                secondCateBtn.titleLabel.font = SYSTEMFONT(16);
                [secondCateBtn setTop:8.5];
                [secondCateBtn setWidth:secondCateBtn.titleLabel.text.length > 6 ? 86 : secondCateBtn.titleLabel.intrinsicContentSize.width];
                XX = secondCateBtn.right + 16;
                _mainCateSelectIcon.centerX = secondCateBtn.centerX;
            }
        }
        _mainCateScrollView.contentSize = CGSizeMake(XX, 0);
        
        TeacherCategoryModel *model = (TeacherCategoryModel *)_mainCateArray[index - 10];
        [_secondCateArray removeAllObjects];
        [_secondCateArray addObjectsFromArray:model.child];
        [self makeSecondCateUI];
    }
}

// MARK: - 小分类滚动视图构建
- (void)makeSecondCateView {
    _secondCateScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _shopFaceImage.bottom, MainScreenWidth, 0)];
    _secondCateScrollView.backgroundColor = EdlineV5_Color.backColor;
    _secondCateScrollView.showsVerticalScrollIndicator = NO;
    _secondCateScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_secondCateScrollView];
}

// MARK: - 小分类ui布局
- (void)makeSecondCateUI {
    [_secondCateScrollView removeAllSubviews];
    _secondCateScrollView.frame = CGRectMake(0, _shopFaceImage.bottom, MainScreenWidth, SWNOTEmptyArr(_secondCateArray) ? 56 : 0);
    _collectionView.frame = CGRectMake(0, _secondCateScrollView.bottom, MainScreenWidth, MainScreenHeight - _secondCateScrollView.bottom);
    if (SWNOTEmptyArr(_secondCateArray)) {
        CGFloat XX = 15;
        for (int i = 0; i<_secondCateArray.count; i++) {
            UIButton *secondCateBtn = [[UIButton alloc] initWithFrame:CGRectMake(XX, 16, 100, 24)];
            secondCateBtn.tag = 10 + i;
            secondCateBtn.titleLabel.font = SYSTEMFONT(13);
            secondCateBtn.layer.masksToBounds = YES;
            secondCateBtn.layer.cornerRadius = secondCateBtn.height / 2.0;
            secondCateBtn.backgroundColor = HEXCOLOR(0xEDEDED);
            CateGoryModelSecond *model = (CateGoryModelSecond *)_secondCateArray[i];
            [secondCateBtn setTitle:model.title forState:0];
            [secondCateBtn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
            [secondCateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [secondCateBtn setWidth:secondCateBtn.titleLabel.text.length > 6 ? 86 : secondCateBtn.titleLabel.intrinsicContentSize.width + 16];
            XX = secondCateBtn.right + 12;
            [secondCateBtn addTarget:self action:@selector(secondCateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_secondCateScrollView addSubview:secondCateBtn];
            if (i == 0) {
                cateId = [NSString stringWithFormat:@"%@",model.cateGoryId];
                secondCateBtn.selected = YES;
                CAGradientLayer *gradientLayer = [CAGradientLayer layer];
                gradientLayer.frame = secondCateBtn.bounds;
                // 渐变色颜色数组,可多个
                gradientLayer.colors = [NSArray arrayWithObjects:(id)[HEXCOLOR(0xFF3B2F) CGColor], (id)[HEXCOLOR(0xFF8A52) CGColor], nil];
                // 渐变的开始点 (不同的起始点可以实现不同位置的渐变,如图)
                gradientLayer.startPoint = CGPointMake(0, 0.5f); //(0, 0)
                // 渐变的结束点
                gradientLayer.endPoint = CGPointMake(1, 0.5f); //(1, 1)
                [secondCateBtn.layer insertSublayer:gradientLayer atIndex:0];
            }
        }
        _secondCateScrollView.contentSize = CGSizeMake(XX, 0);
        [_collectionView.mj_header beginRefreshing];
    } else {
        [_collectionView.mj_header beginRefreshing];
    }
}

// MARK: - 小分类按钮点击事件
- (void)secondCateButtonClick:(UIButton *)sender {
    NSInteger index = sender.tag;
    [_secondCateScrollView removeAllSubviews];
    if (SWNOTEmptyArr(_secondCateArray)) {
        CGFloat XX = 15;
        for (int i = 0; i<_secondCateArray.count; i++) {
            UIButton *secondCateBtn = [[UIButton alloc] initWithFrame:CGRectMake(XX, 16, 100, 24)];
            secondCateBtn.tag = 10 + i;
            secondCateBtn.titleLabel.font = SYSTEMFONT(13);
            secondCateBtn.layer.masksToBounds = YES;
            secondCateBtn.layer.cornerRadius = secondCateBtn.height / 2.0;
            secondCateBtn.backgroundColor = HEXCOLOR(0xEDEDED);
            CateGoryModelSecond *model = (CateGoryModelSecond *)_secondCateArray[i];
            [secondCateBtn setTitle:model.title forState:0];
            [secondCateBtn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
            [secondCateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [secondCateBtn setWidth:secondCateBtn.titleLabel.text.length > 6 ? 86 : secondCateBtn.titleLabel.intrinsicContentSize.width + 16];
            XX = secondCateBtn.right + 12;
            [secondCateBtn addTarget:self action:@selector(secondCateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_secondCateScrollView addSubview:secondCateBtn];
            if (i == (index - 10)) {
                cateId = [NSString stringWithFormat:@"%@",model.cateGoryId];
                secondCateBtn.selected = YES;
                CAGradientLayer *gradientLayer = [CAGradientLayer layer];
                gradientLayer.frame = secondCateBtn.bounds;
                // 渐变色颜色数组,可多个
                gradientLayer.colors = [NSArray arrayWithObjects:(id)[HEXCOLOR(0xFF3B2F) CGColor], (id)[HEXCOLOR(0xFF8A52) CGColor], nil];
                // 渐变的开始点 (不同的起始点可以实现不同位置的渐变,如图)
                gradientLayer.startPoint = CGPointMake(0, 0.5f); //(0, 0)
                // 渐变的结束点
                gradientLayer.endPoint = CGPointMake(1, 0.5f); //(1, 1)
                [secondCateBtn.layer insertSublayer:gradientLayer atIndex:0];
            }
        }
        _secondCateScrollView.contentSize = CGSizeMake(XX, 0);
        [_collectionView.mj_header beginRefreshing];
    }
}

- (void)setCateUI {
    int count = arc4random() % 9;
    count = (count>8?8:count);
    int m = 0;
    CGFloat HH = 28 + 4 + 16;
    for (int i = 0; i < count; i++) {
        m = i/4;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((i%4)*(_cateView.width/4), m * (HH + 15) + 15, _cateView.width/4, HH);
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        img.clipsToBounds = YES;
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.centerX = btn.width / 2.0;
        img.image = DefaultImage;
//        NSString *imageName = [info[i] objectForKey:@"icon"];
//        if (SWNOTEmptyStr(imageName)) {
//            [img sd_setImageWithURL:EdulineUrlString(imageName) placeholderImage:DefaultImage];
//        } else {
//            img.image = DefaultImage;
//        }
        [btn addSubview:img];
        UILabel *titlelL = [[UILabel alloc] initWithFrame:CGRectMake(0, img.bottom + 4, _cateView.width/4, 16)];
        titlelL.font = SYSTEMFONT(13);
        titlelL.textColor = EdlineV5_Color.textSecendColor;
        titlelL.textAlignment = NSTextAlignmentCenter;
        titlelL.text = @"草泥马";//[info[i] objectForKey:@"title"];
        [btn addSubview:titlelL];
        btn.tag = 66 + i;
        [btn addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cateView addSubview:btn];
        if (i == (count - 1)) {
            [_cateView setHeight:btn.bottom + 15];
        }
    }
}

- (void)typeButtonClick:(UIButton *)sender {
}

// MARK: - 顶部搜索框点击事件
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    ShopSearchVC *vc = [[ShopSearchVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}

// MARK: - 构建列表collectionView
- (void)makeCollectionView {
    UICollectionViewFlowLayout *cellLayout = [[UICollectionViewFlowLayout alloc] init];
    cellLayout.itemSize = CGSizeMake(MainScreenWidth / 2.0, MainScreenWidth/2.0 - 4.5 - 15 + 118 + 9);
    cellLayout.minimumInteritemSpacing = 0;
    cellLayout.minimumLineSpacing = 0;
    
//#define shopMainCellWidth (MainScreenWidth/2.0 - 4.5 - 15)
//#define shopMainCellHeight (MainScreenWidth/2.0 - 4.5 - 15 + 118)
    cellLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _secondCateScrollView.bottom, MainScreenWidth, MainScreenHeight - _secondCateScrollView.bottom) collectionViewLayout:cellLayout];
    [_collectionView registerClass:[ShopMainListCell class] forCellWithReuseIdentifier:@"ShopMainListCell"];
    _collectionView.backgroundColor = EdlineV5_Color.backColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
}

// MARK: - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (SWNOTEmptyArr(_secondCateArray)) {
        CGSize size = CGSizeMake(0, 0);
        return size;
    } else {
        CGSize size = CGSizeMake(0, 16);
        return size;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShopMainListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShopMainListCell" forIndexPath:indexPath];
    [cell setShopMainListInfo:_dataSource[indexPath.row] cellIndex:indexPath];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ShopDetailViewController *vc = [[ShopDetailViewController alloc] init];
    vc.shopId = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"id"]];
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - 获取第一页列表数据
- (void)getShopMainList {
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    
    if (SWNOTEmptyStr(cateId)) {
        if ([cateId isEqualToString:@"-1"]) {
            [param setObject:@"1" forKey:@"recommend"];
        } else {
            [param setObject:cateId forKey:@"category"];
        }
    }
    
    if (SWNOTEmptyStr(_institutionSearch.text)) {
        [param setObject:_institutionSearch.text forKey:@"title"];
    }
    [_collectionView collectionViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_collectionView.height];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path shopMainList] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        [_collectionView.mj_header endRefreshing];
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                if (_dataSource.count<15) {
                    _collectionView.mj_footer.hidden = YES;
                } else {
                    [_collectionView.mj_footer setState:MJRefreshStateIdle];
                    _collectionView.mj_footer.hidden = NO;
                }
                [_collectionView collectionViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_collectionView.height];
                [_collectionView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        [_collectionView.mj_header endRefreshing];
    }];
}

// MARK: - 获取更多页数据
- (void)getShopMainMoreList {
    page = page + 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    
    if (SWNOTEmptyStr(cateId)) {
        if ([cateId isEqualToString:@"-1"]) {
            [param setObject:@"1" forKey:@"recommend"];
        } else {
            [param setObject:cateId forKey:@"category"];
        }
    }
    
    if (SWNOTEmptyStr(_institutionSearch.text)) {
        [param setObject:_institutionSearch.text forKey:@"title"];
    }
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseMainList] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_collectionView.mj_footer.isRefreshing) {
            [_collectionView.mj_footer endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSArray *pass = [NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                if (pass.count<15) {
                    [_collectionView.mj_footer endRefreshingWithNoMoreData];
                }
                [_dataSource addObjectsFromArray:pass];
                [_collectionView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        page--;
        if (_collectionView.mj_footer.isRefreshing) {
            [_collectionView.mj_footer endRefreshing];
        }
    }];
}

// MARK: - ShopMainListCellDelegate(立即兑换按钮点击事件)
- (void)exchangeNowButton:(NSDictionary *)shopInfo {
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    ShopOrderSureVC *vc = [[ShopOrderSureVC alloc] init];
    vc.shopID = [NSString stringWithFormat:@"%@",shopInfo[@"id"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getShopCateInfo {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path commonCategoryNet] WithAuthorization:nil paramDic:@{@"type":@"6"} finish:^(id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]) {
            NSMutableArray *pass = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"data"]];
            for (int i = 0; i<pass.count; i ++) {
                NSMutableDictionary *passdict = [NSMutableDictionary dictionaryWithDictionary:pass[i]];
                NSDictionary *allDict = @{@"title":@"全部",@"id":[NSString stringWithFormat:@"%@",passdict[@"id"]]};
                NSMutableArray *mtu = [[NSMutableArray alloc] init];
                if (passdict[@"child"]) {
                    mtu = [NSMutableArray arrayWithArray:passdict[@"child"]];
                    if (SWNOTEmptyArr(mtu)) {
                        [mtu insertObject:allDict atIndex:0];
                    }
                }
                [passdict setObject:[NSArray arrayWithArray:mtu] forKey:@"child"];
                [pass replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithDictionary:passdict]];
            }
            NSDictionary *allDict = @{@"title":@"推荐",@"id":@"-1",@"child":@[]};
            [pass insertObject:allDict atIndex:0];
            [_mainCateArray addObjectsFromArray:[NSArray arrayWithArray:[TeacherCategoryModel mj_objectArrayWithKeyValuesArray:[NSArray arrayWithArray:pass]]]];
            [self makeMainCateUI];
        }
    } enError:^(NSError * _Nonnull error) {
        
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
