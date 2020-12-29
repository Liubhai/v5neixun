//
//  ExamMainViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/11/13.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "ExamMainViewController.h"
#import "V5_Constant.h"

#import "ExamMainListCell.h"

#import "SpecialProjectExamList.h"
#import "ExamPointSelectVC.h"

@interface ExamMainViewController () {
    NSInteger page;
}

@end

@implementation ExamMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    page = 1;
    _dataSource = [NSMutableArray new];
    [_dataSource addObjectsFromArray:@[@{@"image":@"find_album_icon",@"title":@"公开考试"},@{@"image":@"find_test_icon",@"title":@"专项练习"},@{@"image":@"find_library_icon",@"title":@"知识点练习"},@{@"image":@"find_q&a_icon",@"title":@"套卷练习"}]];
    _titleLabel.text = @"考试";
    [self makeCollectionView];
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCourseMainList)];
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getCourseMainListMoreData)];
    _collectionView.mj_footer.hidden = YES;
//    [_collectionView.mj_header beginRefreshing];
    [_collectionView reloadData];
}

- (void)makeCollectionView {
    UICollectionViewFlowLayout *cellLayout = [[UICollectionViewFlowLayout alloc] init];
    cellLayout.itemSize = CGSizeMake(MainScreenWidth / 2.0, (MainScreenHeight - MACRO_UI_UPHEIGHT - 20 * 2)/2.0);
    cellLayout.minimumInteritemSpacing = 0;
    cellLayout.minimumLineSpacing = 0;
    
    cellLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT) collectionViewLayout:cellLayout];
    [_collectionView registerClass:[ExamMainListCell class] forCellWithReuseIdentifier:@"ExamMainListCell"];
    _collectionView.backgroundColor = [UIColor whiteColor];
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
    return UIEdgeInsetsMake(20, 0, 20, 0);//分别为上、左、下、右
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ExamMainListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExamMainListCell" forIndexPath:indexPath];
    [cell setExamMainListInfo:_dataSource[indexPath.row] cellIndex:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSString *examTheme = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"title"]];
    if ([examTheme isEqualToString:@"公开考试"]) {
        SpecialProjectExamList *vc = [[SpecialProjectExamList alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([examTheme isEqualToString:@"知识点练习"]) {
        ExamPointSelectVC *vc = [[ExamPointSelectVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)getCourseMainList {
//    page = 1;
//    NSMutableDictionary *param = [NSMutableDictionary new];
//    [param setObject:@(page) forKey:@"page"];
//    // 大类型
//    if (SWNOTEmptyStr(coursetypeIdString)) {
//        [param setObject:coursetypeIdString forKey:@"course_type"];
//    }
//    // 小分类
//    if (SWNOTEmptyStr(courseClassifyIdString)) {
//        [param setObject:courseClassifyIdString forKey:@"category"];
//    }
//    // 排序
//    if (SWNOTEmptyStr(courseSortIdString)) {
//        [param setObject:courseSortIdString forKey:@"order"];
//    }
//    // 筛选
//    if (SWNOTEmptyStr(screenId)) {
//        [param setObject:screenId forKey:@""];
//    }
//    if (SWNOTEmptyStr(screenPriceUpAndDown)) {
//        [param setObject:screenPriceUpAndDown forKey:@"price_order"];
//    }
//    if (SWNOTEmptyStr(minPrice)) {
//        [param setObject:minPrice forKey:@"price_min"];
//    }
//    if (SWNOTEmptyStr(maxPrice)) {
//        [param setObject:maxPrice forKey:@"price_max"];
//    }
//
//    if (SWNOTEmptyStr(screenType)) {
//        [param setObject:screenType forKey:@"param"];
//    }
//
//    if (SWNOTEmptyStr(_institutionSearch.text)) {
//        [param setObject:_institutionSearch.text forKey:@"title"];
//    }
//    [_collectionView collectionViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_collectionView.height];
//    [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseMainList] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
//        [_collectionView.mj_header endRefreshing];
//        if (SWNOTEmptyDictionary(responseObject)) {
//            if ([[responseObject objectForKey:@"code"] integerValue]) {
//                [_dataSource removeAllObjects];
//                [_dataSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
//                if (_dataSource.count<15) {
//                    _collectionView.mj_footer.hidden = YES;
//                } else {
//                    _collectionView.mj_footer.hidden = NO;
//                }
//                [_collectionView collectionViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_collectionView.height];
//                [_collectionView reloadData];
//            }
//        }
//    } enError:^(NSError * _Nonnull error) {
//        [_collectionView.mj_header endRefreshing];
//    }];
}

- (void)getCourseMainListMoreData {
//    page = page + 1;
//    NSMutableDictionary *param = [NSMutableDictionary new];
//    [param setObject:@(page) forKey:@"page"];
//    // 大类型
//    if (SWNOTEmptyStr(coursetypeIdString)) {
//        [param setObject:coursetypeIdString forKey:@"course_type"];
//    }
//    // 小分类
//    if (SWNOTEmptyStr(courseClassifyIdString)) {
//        [param setObject:courseClassifyIdString forKey:@"category"];
//    }
//    // 排序
//    if (SWNOTEmptyStr(courseSortIdString)) {
//        [param setObject:courseSortIdString forKey:@"order"];
//    }
//    // 筛选
//    if (SWNOTEmptyStr(screenId)) {
//        [param setObject:screenId forKey:@""];
//    }
//    if (SWNOTEmptyStr(screenPriceUpAndDown)) {
//        [param setObject:screenPriceUpAndDown forKey:@"price_order"];
//    }
//    if (SWNOTEmptyStr(minPrice)) {
//        [param setObject:minPrice forKey:@"price_min"];
//    }
//    if (SWNOTEmptyStr(maxPrice)) {
//        [param setObject:maxPrice forKey:@"price_max"];
//    }
//    if (SWNOTEmptyStr(screenType)) {
//        [param setObject:screenType forKey:@"param"];
//    }
//    if (SWNOTEmptyStr(_institutionSearch.text)) {
//        [param setObject:_institutionSearch.text forKey:@"title"];
//    }
//    [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseMainList] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
//        if (_collectionView.mj_footer.isRefreshing) {
//            [_collectionView.mj_footer endRefreshing];
//        }
//        if (SWNOTEmptyDictionary(responseObject)) {
//            if ([[responseObject objectForKey:@"code"] integerValue]) {
//                NSArray *pass = [NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
//                if (pass.count<15) {
//                    [_collectionView.mj_footer endRefreshingWithNoMoreData];
//                }
//                [_dataSource addObjectsFromArray:pass];
//                [_collectionView reloadData];
//            }
//        }
//    } enError:^(NSError * _Nonnull error) {
//        page--;
//        if (_collectionView.mj_footer.isRefreshing) {
//            [_collectionView.mj_footer endRefreshing];
//        }
//    }];
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
