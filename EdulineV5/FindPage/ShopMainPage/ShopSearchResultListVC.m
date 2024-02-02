//
//  ShopSearchResultListVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/11/1.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "ShopSearchResultListVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "ShopMainListCell.h"

#import "ShopDetailViewController.h"
#import "ShopOrderSureVC.h"

#import "AppDelegate.h"
#import "V5_UserModel.h"

@interface ShopSearchResultListVC ()<UITextFieldDelegate, ShopMainListCellDelegate> {
    NSInteger page;
    NSString *cateId;
}

@property (strong, nonatomic) UITextField *institutionSearch;

@end

@implementation ShopSearchResultListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = EdlineV5_Color.backColor;

    _dataSource = [NSMutableArray new];
    
    _rightButton.hidden = NO;
    [_rightButton setTitle:@"搜索" forState:0];
    [_rightButton setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    [_rightButton setImage:nil forState:0];
    
    _lineTL.backgroundColor = [UIColor whiteColor];
    [self makeTopSearch];
    
    [self makeCollectionView];
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getShopMainList)];
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getShopMainMoreList)];
    _collectionView.mj_footer.hidden = YES;
    [_collectionView.mj_header beginRefreshing];
    [_collectionView reloadData];
    [EdulineV5_Tool adapterOfIOS11With:_collectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    // Do any additional setup after loading the view.
}

- (void)makeTopSearch {
    // 顶部搜索框和 取消按钮
    _institutionSearch = [[UITextField alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.top - 2, _titleLabel.width, 36)];
    _institutionSearch.font = SYSTEMFONT(14);
    _institutionSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索商品" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _institutionSearch.delegate = self;
    _institutionSearch.returnKeyType = UIReturnKeySearch;
    _institutionSearch.layer.cornerRadius = 18;
    _institutionSearch.backgroundColor = EdlineV5_Color.backColor;
    _institutionSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    _institutionSearch.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 17 + 15 + 10, 30)];
    _institutionSearch.leftViewMode = UITextFieldViewModeAlways;
    _institutionSearch.clearButtonMode = UITextFieldViewModeAlways;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(17, 7.5, 15, 15)];
    [button setImage:Image(@"home_serch_icon") forState:UIControlStateNormal];
    [_institutionSearch.leftView addSubview:button];
    [_titleImage addSubview:_institutionSearch];
    if (SWNOTEmptyStr(_searchKeyWord)) {
        _institutionSearch.text = _searchKeyWord;
    }
}

// MARK: - 构建列表collectionView
- (void)makeCollectionView {
    UICollectionViewFlowLayout *cellLayout = [[UICollectionViewFlowLayout alloc] init];
    cellLayout.itemSize = CGSizeMake(MainScreenWidth / 2.0, MainScreenWidth/2.0 - 4.5 - 15 + 118 + 9);
    cellLayout.minimumInteritemSpacing = 0;
    cellLayout.minimumLineSpacing = 0;

    cellLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT) collectionViewLayout:cellLayout];
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
    return UIEdgeInsetsMake(9, 0, 0, 0);//分别为上、左、下、右
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

- (void)textfieldDidChanged:(NSNotification *)notice {
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_institutionSearch resignFirstResponder];
        [self getShopMainList];
        return NO;
    }
    return YES;
}

- (void)getShopMainList {
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    
    if (SWNOTEmptyStr(cateId)) {
        [param setObject:cateId forKey:@"category"];
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
        [param setObject:cateId forKey:@"category"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
