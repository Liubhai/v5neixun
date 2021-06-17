//
//  TeahcerCourseListVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "TeahcerCourseListVC.h"
#import "V5_Constant.h"
#import "CourseSearchListCell.h"
#import "Net_Path.h"
#import "EdulineV5_Tool.h"
#import "CourseMainViewController.h"

#define topViewHeight 53

@interface TeahcerCourseListVC () {
    NSInteger page;
    
    // 课程类型
    NSString *coursetypeIdString;
}

@property (strong, nonatomic) NSArray *typeArray;
@property (strong, nonatomic) UIView *topView;

@end

@implementation TeahcerCourseListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    page = 1;
    coursetypeIdString = @"0";
    _typeArray = @[@{@"title":@"推荐",@"id":@"0"},@{@"title":@"点播",@"id":@"1"},@{@"title":@"直播",@"id":@"2"},@{@"title":@"面授",@"id":@"3"}];
    _dataSource = [NSMutableArray new];
    _titleImage.hidden = YES;
    [self addHeaderView];
    [self makeCollectionView];
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCourseMainList)];
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getCourseMainListMoreData)];
    _collectionView.mj_footer.hidden = YES;
    [_collectionView.mj_header beginRefreshing];
    [EdulineV5_Tool adapterOfIOS11With:_collectionView];
}

- (void)addHeaderView {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, topViewHeight)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topView];
    for (int i = 0; i < _typeArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15 + 77 * i, 15, 65, 28)];
        btn.tag = 100 + i;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 14;
        [btn setTitle:_typeArray[i][@"title"] forState:0];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
        btn.titleLabel.font = SYSTEMFONT(14);
        [btn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:btn];
        if (i == 0) {
            btn.selected = YES;
            btn.backgroundColor = EdlineV5_Color.themeColor;
        } else {
            btn.selected = NO;
            [btn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        }
    }
}

- (void)makeCollectionView {
    UICollectionViewFlowLayout *cellLayout = [[UICollectionViewFlowLayout alloc] init];
    cellLayout.itemSize = CGSizeMake((MainScreenWidth - 12) / 2.0, 20 + (MainScreenWidth/2.0 - 6 - 15) * 90 / 165.0 + 6 + 20 + 13 + 16 + 3);
    cellLayout.minimumLineSpacing = 0;
    cellLayout.minimumInteritemSpacing = 6;
    cellLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, topViewHeight, MainScreenWidth, _tabelHeight - topViewHeight) collectionViewLayout:cellLayout];
    [_collectionView registerClass:[CourseSearchListCell class] forCellWithReuseIdentifier:@"CourseSearchListCell"];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CourseSearchListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CourseSearchListCell" forIndexPath:indexPath];
    [cell setCourseListInfo:_dataSource[indexPath.row] cellIndex:indexPath cellType:YES];
    return cell;
}


//- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 200);
//    return size;
//}
//
//// 创建一个继承collectionReusableView的类,用法类比tableViewcell
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    UICollectionReusableView *reusableView = nil;
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        // 头部视图
//        // 代码初始化表头
//         [collectionView registerClass:[TeacherCourseListHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TeacherCourseListHeaderView"];
//        // xib初始化表头
////        [collectionView registerNib:[UINib nibWithNibName:@"HeaderReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderReusableView"];
//        TeacherCourseListHeaderView *tempHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TeacherCourseListHeaderView" forIndexPath:indexPath];
//        reusableView = tempHeaderView;
//    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
//        // 底部视图
//    }
//    return reusableView;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    CourseMainViewController *vc = [[CourseMainViewController alloc] init];
    vc.ID = [NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"id"]];
    vc.courselayer = [NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"section_level"]];
    vc.isLive = [[NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"course_type"]] isEqualToString:@"2"] ? YES : NO;
    vc.courseType = [NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"course_type"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)typeBtnClick:(UIButton *)sender {
    for (UIButton *btn in _topView.subviews) {
        if (btn.tag == sender.tag) {
            btn.selected = YES;
            [btn setBackgroundColor:EdlineV5_Color.themeColor];
        } else {
            btn.selected = NO;
            [btn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        }
    }
    coursetypeIdString = [NSString stringWithFormat:@"%@",_typeArray[sender.tag - 100][@"id"]];
    [self getCourseMainList];
}

- (void)getCourseMainList {
    if (!SWNOTEmptyStr(_teacherId)) {
        [_collectionView.mj_header endRefreshing];
        return;
    }
    
    NSString *getUrl = [Net_Path teacherCourseListInfo:_teacherId];
    if (_isUserHomePage) {
        getUrl = [Net_Path userHomeCourseListNet];
    }
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    // 大类型
    if (SWNOTEmptyStr(coursetypeIdString)) {
        [param setObject:coursetypeIdString forKey:@"course_type"];
    }
    [Net_API requestGETSuperAPIWithURLStr:getUrl WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        [_collectionView.mj_header endRefreshing];
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                if (_dataSource.count<10) {
                    _collectionView.mj_footer.hidden = YES;
                } else {
                    _collectionView.mj_footer.hidden = NO;
                }
                [_collectionView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        [_collectionView.mj_header endRefreshing];
    }];
}

- (void)getCourseMainListMoreData {
    NSString *getUrl = [Net_Path teacherCourseListInfo:_teacherId];
    if (_isUserHomePage) {
        getUrl = [Net_Path userHomeCourseListNet];
    }
    page = page + 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    // 大类型
    if (SWNOTEmptyStr(coursetypeIdString)) {
        [param setObject:coursetypeIdString forKey:@"course_type"];
    }
    [Net_API requestGETSuperAPIWithURLStr:getUrl WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_collectionView.mj_footer.isRefreshing) {
            [_collectionView.mj_footer endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSArray *pass = [NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                if (pass.count<10) {
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

@end
