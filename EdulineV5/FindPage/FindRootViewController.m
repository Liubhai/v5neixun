//
//  FindRootViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "FindRootViewController.h"
#import "V5_Constant.h"
#import "FindListCell.h"
#import "Net_Path.h"
#import "InstitutionListVC.h"
#import "ZiXunListVC.h"

@interface FindRootViewController ()

@end

@implementation FindRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _leftButton.hidden = YES;
    _cellType = NO;
    _dataSource = [NSMutableArray new];
//    if (_cellType) {
//        [_dataSource addObjectsFromArray:@[@{@"image":@"find_album_icon",@"title":@"专辑课"},@{@"image":@"find_test_icon",@"title":@"考试"},@{@"image":@"find_library_icon",@"title":@"文库"},@{@"image":@"find_q&a_icon",@"title":@"问答"},@{@"image":@"find_news_icon",@"title":@"资讯"},@{@"image":@"find_pengyouquan_icon",@"title":@"朋友圈"},@{@"image":@"find_pengyouquan_icon",@"title":@"商城"}]];
//    } else {
//        [_dataSource addObjectsFromArray:@[@{@"image":@"find_album_list",@"title":@"专辑课"},@{@"image":@"find_test_list",@"title":@"考试"},@{@"image":@"find_library_list",@"title":@"文库"},@{@"image":@"find_q&a_list",@"title":@"问答"},@{@"image":@"find_news_list",@"title":@"资讯"},@{@"image":@"find_pengyouquan_list",@"title":@"朋友圈"},@{@"image":@"find_pengyouquan_list",@"title":@"商城"}]];
//    }
    
    _titleLabel.hidden = YES;
    
    NSString *themeString = @"发现";
    CGFloat themeWidth = [themeString sizeWithFont:SYSTEMFONT(22)].width + 4;
    
    UILabel *theme = [[UILabel alloc] initWithFrame:CGRectMake(15, _titleLabel.bottom - 25, themeWidth, 25)];
    theme.text = themeString;
    theme.font = SYSTEMFONT(22);
    theme.textColor = EdlineV5_Color.textFirstColor;
    theme.textAlignment = NSTextAlignmentCenter;
    [_titleImage addSubview:theme];
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(15,theme.bottom - 10,themeWidth,10);
    view.layer.backgroundColor = [UIColor colorWithRed:81/255.0 green:145/255.0 blue:255/255.0 alpha:0.2].CGColor;
    [_titleImage addSubview:view];
    
    [self makeCollectionView];
}

- (void)makeCollectionView {
    UICollectionViewFlowLayout *cellLayout = [[UICollectionViewFlowLayout alloc] init];
    if (_cellType) {
        cellLayout.itemSize = CGSizeMake((MainScreenWidth - 6) / 2.0, (MainScreenWidth - 6) / 2.0);
        cellLayout.minimumInteritemSpacing = 0;
        cellLayout.minimumLineSpacing = 0;
    } else {
        cellLayout.itemSize = CGSizeMake(MainScreenWidth, 50);
        cellLayout.minimumInteritemSpacing = 0;
        cellLayout.minimumLineSpacing = 0;
    }
    
    cellLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_TABBAR_HEIGHT) collectionViewLayout:cellLayout];
    [_collectionView registerClass:[FindListCell class] forCellWithReuseIdentifier:@"FindListCell"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCourseMainList)];
    [self.view addSubview:_collectionView];
    [_collectionView.mj_header beginRefreshing];
}

// MARK: - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FindListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FindListCell" forIndexPath:indexPath];
    [cell setFindListInfo:_dataSource[indexPath.row] cellIndex:indexPath cellType:_cellType];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSString *keyType = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"key"]];
    if ([keyType isEqualToString:@"school"]) {
        InstitutionListVC *vc = [[InstitutionListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([keyType isEqualToString:@"news"]) {
        ZiXunListVC *vc = [[ZiXunListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)getCourseMainList {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path findPageNet] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        [_collectionView.mj_header endRefreshing];
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[responseObject objectForKey:@"data"]];
                [_collectionView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        [_collectionView.mj_header endRefreshing];
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
