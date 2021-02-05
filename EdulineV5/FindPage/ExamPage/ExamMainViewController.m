//
//  ExamMainViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/11/13.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "ExamMainViewController.h"
#import "V5_Constant.h"
#import "Net_Path.h"

#import "ExamMainListCell.h"

#import "SpecialProjectExamList.h"
#import "ExamPointSelectVC.h"

#import "TaojuanListViewController.h"

#import "ZhuangXiangListTreeTableVC.h"

#import "ExamResultViewController.h"
#import "AnswerSheetViewController.h"

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
    _titleLabel.text = @"考试";
    _lineTL.hidden = NO;
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self makeCollectionView];
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCourseMainList)];
    _collectionView.mj_footer.hidden = YES;
    [_collectionView.mj_header beginRefreshing];
    [_collectionView reloadData];
    [EdulineV5_Tool adapterOfIOS11With:_collectionView];
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
    NSString *examTheme = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"module_type"]];
    if ([examTheme isEqualToString:@"3"]) {
        SpecialProjectExamList *vc = [[SpecialProjectExamList alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([examTheme isEqualToString:@"1"]) {
        ExamPointSelectVC *vc = [[ExamPointSelectVC alloc] init];
        vc.examTypeString = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"title"]];
        vc.examTypeId = examTheme;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (([examTheme isEqualToString:@"4"])) {
        TaojuanListViewController *vc = [[TaojuanListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([examTheme isEqualToString:@"2"]) {
//        ZhuangXiangListTreeTableVC *vc = [[ZhuangXiangListTreeTableVC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
        
//        AnswerSheetViewController  ExamResultViewController
        AnswerSheetViewController *vc = [[AnswerSheetViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}


//版块类型【1:知识点练习  2: 专项练习 3:公开考试 4: 套卷练习】

- (void)getCourseMainList {
    [_collectionView collectionViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_collectionView.height];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path examMainPageNet] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        [_collectionView.mj_header endRefreshing];
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[responseObject objectForKey:@"data"]];
                [_collectionView collectionViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_collectionView.height];
                [_collectionView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        [_collectionView.mj_header endRefreshing];
    }];
}

@end
