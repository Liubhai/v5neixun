//
//  CourseStudentListViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/27.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseStudentListViewController.h"
#import "CourseStudentsCollectionCell.h"

@interface CourseStudentListViewController ()

@end

@implementation CourseStudentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    _titleImage.hidden = YES;
    _canPlayRecordVideo = YES;
    _dataSource = [NSMutableArray new];
    [self makeCollectionView];
//    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getFirstList)];
//    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getCourseMainListMoreData)];
//    _collectionView.mj_footer.hidden = YES;
//    [_collectionView.mj_header beginRefreshing];
    
    [self getStudentListInfo];
}

- (void)makeCollectionView {
    UICollectionViewFlowLayout *cellLayout = [[UICollectionViewFlowLayout alloc] init];
    cellLayout.itemSize = CGSizeMake(75, 20 + 50 + 12 + 15);
    cellLayout.minimumInteritemSpacing = (MainScreenWidth - 4 * 75) / 5.0;
    
    cellLayout.sectionInset = UIEdgeInsetsMake(1, 0, 0, 0);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _tabelHeight) collectionViewLayout:cellLayout];
    
    [_collectionView registerClass:[CourseStudentsCollectionCell class] forCellWithReuseIdentifier:@"CourseStudentsCollectionCell"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    [EdulineV5_Tool adapterOfIOS11With:_collectionView];
}

// MARK: - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CourseStudentsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CourseStudentsCollectionCell" forIndexPath:indexPath];
    [cell setStudentInfo:_dataSource[indexPath.row]];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.cellTabelCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        if (self.vc) {
            if (self.vc.canScrollAfterVideoPlay == YES) {
                self.cellTabelCanScroll = NO;
                scrollView.contentOffset = CGPointZero;
                self.vc.canScroll = YES;
            }
        }
    }
}

- (void)getStudentListInfo {
    if (SWNOTEmptyStr(_courseId)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path classCourseStudentListNet:_courseId] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
            [_collectionView.mj_header endRefreshing];
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    [_dataSource removeAllObjects];
                    [_dataSource addObjectsFromArray:[responseObject objectForKey:@"data"]];
//                    if (_dataSource.count<15) {
//                        _collectionView.mj_footer.hidden = YES;
//                    } else {
//                        _collectionView.mj_footer.hidden = NO;
//                    }
                    [_collectionView reloadData];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            [_collectionView.mj_header endRefreshing];
        }];
    }
}

@end
